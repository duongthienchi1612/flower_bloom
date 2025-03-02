part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadData extends HomeEvent {
  final bool? showMenu;
  LoadData({this.showMenu});
}

class ChangeSound extends HomeEvent {
  ChangeSound();
}

class ShowDataLevel extends HomeEvent {
  final bool isShow;
  ShowDataLevel({this.isShow = false});
}
