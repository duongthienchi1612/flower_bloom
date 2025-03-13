import 'package:flower_bloom/dependencies.dart';
import 'package:flower_bloom/model/view/game_view_model.dart';
import 'package:flower_bloom/screen/home_screen.dart';
import 'package:flower_bloom/utilities/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/game_bloc/game_bloc.dart';
import '../constants.dart';
import '../widget/base/base_widget.dart';

class GameScreen extends StatefulWidget {
  final int? level;
  const GameScreen({super.key, this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends BaseState<GameScreen> with TickerProviderStateMixin {
  final audioManager = injector.get<AudioManager>();
  final bloc = injector.get<GameBloc>();

  late AnimationController _levelCompleteController;
  late Animation<double> _scaleAnimation;
  
  // Controller cho animation hoa nở tĩnh
  late AnimationController _staticFlowerController;
  
  // Map để lưu trữ trạng thái animation của từng ô
  final Map<String, bool> _tileAnimationStates = {};
  
  // Biến để kiểm tra xem có animation nào đang chạy không
  bool _isAnyAnimationRunning = false;

  @override
  void initState() {
    super.initState();

    _levelCompleteController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _levelCompleteController, curve: Curves.elasticOut),
    );
    
    // Khởi tạo controller cho animation hoa nở tĩnh
    _staticFlowerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1),
    );
    
    // Đặt giá trị cụ thể để hiển thị frame mong muốn (0.8 là ví dụ, có thể điều chỉnh)
    _staticFlowerController.value = 0.9;
  }

  @override
  void dispose() {
    _levelCompleteController.dispose();
    _staticFlowerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.background),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocProvider(
          create: (context) => bloc..add(LoadGame(level: widget.level)),
          child: BlocConsumer<GameBloc, GameState>(
            listener: (context, state) {
              if (state is GameLoaded && state.model.isWin) {
                _levelCompleteController.forward();
                _levelCompleteController.forward(from: 0.0);
              }
              
              // Khi ResetGame hoặc NextLevel được gọi, xóa tất cả trạng thái animation
              if (state is GameLoaded && state.model.lastToggled == null) {
                _tileAnimationStates.clear();
                _isAnyAnimationRunning = false;
              }
              
              // Cập nhật trạng thái animation khi có ô được nhấn
              if (state is GameLoaded && state.model.lastToggled != null) {
                final lastToggled = state.model.lastToggled!;
                
                // Đánh dấu có animation đang chạy
                _isAnyAnimationRunning = true;
                
                // Cập nhật trạng thái animation cho ô được nhấn và các ô xung quanh
                final positions = [
                  'tile_${lastToggled.row}${lastToggled.col}',
                  'tile_${lastToggled.row - 1}${lastToggled.col}',
                  'tile_${lastToggled.row + 1}${lastToggled.col}',
                  'tile_${lastToggled.row}${lastToggled.col - 1}',
                  'tile_${lastToggled.row}${lastToggled.col + 1}',
                ];
                
                for (final tileKey in positions) {
                  _tileAnimationStates[tileKey] = true;
                }
                
                // Đặt timer để chuyển sang trạng thái hoàn thành sau khi animation kết thúc
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) {
                    setState(() {
                      for (final tileKey in positions) {
                        _tileAnimationStates[tileKey] = false;
                      }
                      _isAnyAnimationRunning = false;
                    });
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is GameLoaded) {
                final model = state.model;
                return Stack(
                  children: [
                    model.isWin && model.level < Constants.totalLevel
                        ? Center(
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Level Complete',
                                      style: theme.textTheme.headlineMedium!.copyWith(color: Colors.white)),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(ImagePath.icStarActive, width: 38),
                                      SizedBox(width: 8),
                                      Image.asset(ImagePath.icStarActive, width: 38),
                                      SizedBox(width: 8),
                                      Image.asset(ImagePath.icStarActive, width: 38)
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          audioManager.playSoundEffect(SoundEffect.buttonClick);
                                          bloc.add(ResetGame());
                                        },
                                        highlightColor: Colors.transparent,
                                        icon: Image.asset(ImagePath.icReload, width: 38),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          audioManager.playSoundEffect(SoundEffect.buttonClick);
                                          bloc.add(NextLevel());
                                        },
                                        highlightColor: Colors.transparent,
                                        icon: Image.asset(ImagePath.icPlay, width: 38),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          bloc.audioManager.playSoundEffect(SoundEffect.buttonClick);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomeScreen(
                                                      showMenu: true,
                                                    )),
                                          );
                                        },
                                        highlightColor: Colors.transparent,
                                        icon: Image.asset(ImagePath.icMenuLevel, width: 38),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildGrid(context, model),
                            ],
                          ),
                    Positioned(
                      left: 24,
                      top: 16,
                      child: Row(
                        children: [
                          Text(
                            'Lượt nhấn: ',
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            model.moveCount.toString(),
                            style: theme.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 24,
                      top: 16,
                      child: Text(
                        'Level: ${model.level}',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 16,
                      child: IconButton(
                        onPressed: () {
                          bloc.add(ChangeSound());
                        },
                        highlightColor: Colors.transparent,
                        icon: Image.asset(
                          state.model.isSoundOn ? ImagePath.icSoundOn : ImagePath.icSoundOff,
                          width: 32,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 24,
                      bottom: 16,
                      child: IconButton(
                        onPressed: () {
                          bloc.audioManager.playSoundEffect(SoundEffect.buttonClick);
                          Navigator.pop(context);
                          Navigator.pushNamed(context, ScreenName.home);
                        },
                        icon: Image.asset(
                          ImagePath.icHome,
                          width: 32,
                        ),
                      ),
                    )
                  ],
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, GameViewModel model) {
    final size = MediaQuery.of(context).size;
    double maxWidth = size.width * 0.85; // Chừa 10% viền ngoài
    double maxHeight = size.height * 0.85;
    double gridSize = model.gridSize.toDouble();

    // Chọn cạnh nhỏ hơn của màn hình để làm kích thước tối đa của lưới
    double maxGridSize = maxWidth < maxHeight ? maxWidth : maxHeight;
    double tileSize = maxGridSize / gridSize;

    return Center(
      child: SizedBox(
        width: maxGridSize,
        height: maxGridSize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            model.gridSize,
            (row) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                model.gridSize,
                (col) => _buildFlowerTile(context, model, row, col, tileSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowerTile(BuildContext context, GameViewModel model, int row, int col, double tileSize) {
    bool isBlooming = model.grid[row][col];
    
    // Tạo key cho ô
    final tileKey = 'tile_$row$col';
    
    // Kiểm tra xem ô này có đang trong trạng thái animation không
    bool isAnimating = _tileAnimationStates[tileKey] ?? false;

    return GestureDetector(
      onTap: () {
        // Chỉ cho phép nhấn khi không có animation nào đang chạy
        if (!_isAnyAnimationRunning) {
          bloc.add(ToggleFlower(row, col));
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(2), // Khoảng cách giữa các ô
        width: tileSize - 8, // Giảm nhẹ kích thước để tránh tràn
        height: tileSize - 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isBlooming 
              ? Colors.transparent
              : Colors.grey,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: isAnimating
              ? isBlooming
                  // Khi đang animate và là hoa nở, hiển thị animation hoa nở
                  ? Lottie.asset(
                      ImagePath.flowerBloom,
                      key: ValueKey('bloom_$row$col${DateTime.now().millisecondsSinceEpoch}'),
                      width: tileSize,
                      height: tileSize,
                      fit: BoxFit.contain,
                      repeat: false,
                      frameRate: FrameRate.max,
                    )
                  // Khi đang animate và là lá, hiển thị animation lá
                  : Lottie.asset(
                      ImagePath.leaf,
                      key: ValueKey('leaf_$row$col${DateTime.now().millisecondsSinceEpoch}'),
                      width: tileSize,
                      height: tileSize,
                      fit: BoxFit.contain,
                      repeat: false,
                      frameRate: FrameRate.max,
                    )
              : isBlooming
                  // Khi không animate và là hoa nở, hiển thị frame cụ thể của animation hoa nở
                  ? Lottie.asset(
                      ImagePath.flowerBloom,
                      width: tileSize,
                      height: tileSize,
                      fit: BoxFit.contain,
                      controller: _staticFlowerController,
                      repeat: false,
                      animate: false,
                    )
                  // Khi không animate và là lá, hiển thị animation lá tĩnh
                  : Lottie.asset(
                      ImagePath.leaf,
                      width: tileSize,
                      height: tileSize,
                      fit: BoxFit.contain,
                      repeat: false,
                      frameRate: FrameRate.max,
                      animate: false,
                    ),
        ),
      ),
    );
  }
}
