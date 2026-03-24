abstract class Shape {
  void draw();
  double area();
}

class Circle implements Shape {
  Circle(this.radius);
  final double radius;
  @override
  void draw() => print('Draw circle with radius: $radius');

  @override
  double area() => 3.14 * radius * radius;
}

class Rectangle implements Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  void draw() => print('Draw rectangle with dimensions:${width}x${height}');

  @override
  double area() => width * height;
}

class Triangle implements Shape {
  final double base, height;
  Triangle(this.base, this.height);

  @override
  void draw() => print('Draw triangle with base: $base and height: $height');

  @override
  double area() => 0.5 * base * height;
}

class ShapeFactory {
  static Shape createShape(String type, List<double> params) {
    switch (type) {
      case 'circle':
        return Circle(params[0]);
      case 'rectangle':
        return Rectangle(params[0], params[1]);
      case 'triangle':
        return Triangle(params[0], params[1]);
      default:
        throw Exception('Invalid shape type');
    }
  }
}

void main() {
  final circle = ShapeFactory.createShape('circle', [5.0]);
  circle.draw();
  final circleArea = circle.area();
  print('Circle area:${circleArea}');
}
