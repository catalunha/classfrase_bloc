abstract class CatClassEvent {}

class CatClassEventStart extends CatClassEvent {}

class CatClassEventFilterBy extends CatClassEvent {
  final String filter;
  CatClassEventFilterBy(this.filter);
}
