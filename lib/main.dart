import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ShapeAreaCalculator(),
    );
  }
}

class ShapeAreaCalculator extends StatefulWidget {
  const ShapeAreaCalculator({super.key});

  @override
  State<ShapeAreaCalculator> createState() => _ShapeAreaCalculatorState();
}

class _ShapeAreaCalculatorState extends State<ShapeAreaCalculator> {
  String selectedShape = "";
  String formula = "";
  String result = "";
  double param1 = 0;
  double param2 = 0;
  double param3 = 0; // trapezoid height

  void calculate() {
    setState(() {
      switch (selectedShape) {
        case "Square":
          result = "Area = ${(param1 * param1)}";
          break;

        case "Rectangle":
          result = "Area = ${(param1 * param2)}";
          break;

        case "Circle":
          result = "Area = ${(pi * param1 * param1).toStringAsFixed(2)}";
          break;

        case "Triangle":
          result = "Area = ${(0.5 * param1 * param2)}";
          break;

        case "Cylinder":
          double r = param1;
          double h = param2;
          double area = 2 * pi * r * (r + h); // 2πr(r + h)
          result = "Area = ${area.toStringAsFixed(2)}";
          break;

        case "Trapezoid":
          result = "Area = ${(0.5 * (param1 + param2) * param3)}";
          break;
      }
    });
  }

  void selectShape(String name, String f) {
    setState(() {
      selectedShape = name;
      formula = f;
      result = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: MathBackgroundPainter(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Area Calculator",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  // --- SHAPE BUTTONS ---
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      shapeButton("Square", Icons.square_outlined, "a × a"),
                      shapeButton("Rectangle", Icons.rectangle_outlined, "l × w"),
                      shapeButton("Circle", Icons.circle_outlined, "π × r²"),
                      shapeButton("Triangle", Icons.change_history, "½ × b × h"),
                      shapeButton("Cylinder", Icons.view_in_ar, "2πr(r + h)"),
                      shapeButton("Trapezoid", Icons.format_shapes,
                          "½ × (a + b) × h"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- SELECTED SHAPE BOX ---
                  if (selectedShape.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(18),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Selected Shape: $selectedShape",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20)),
                          const SizedBox(height: 10),
                          Text("Formula: $formula",
                              style: const TextStyle(
                                  color: Colors.orangeAccent, fontSize: 18)),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // --- INPUT FIELDS ---
                  if (selectedShape == "Square")
                    textInput("Side (a)", (v) => param1 = double.tryParse(v) ?? 0),

                  if (selectedShape == "Circle")
                    textInput("Radius (r)", (v) => param1 = double.tryParse(v) ?? 0),

                  if (selectedShape == "Rectangle") ...[
                    textInput("Length (l)",
                        (v) => param1 = double.tryParse(v) ?? 0),
                    const SizedBox(height: 10),
                    textInput("Width (w)",
                        (v) => param2 = double.tryParse(v) ?? 0),
                  ],

                  if (selectedShape == "Triangle") ...[
                    textInput("Base (b)", (v) => param1 = double.tryParse(v) ?? 0),
                    const SizedBox(height: 10),
                    textInput("Height (h)",
                        (v) => param2 = double.tryParse(v) ?? 0),
                  ],

                  // --- CYLINDER INPUT —
                  if (selectedShape == "Cylinder") ...[
                    textInput("Radius (r)",
                        (v) => param1 = double.tryParse(v) ?? 0),
                    const SizedBox(height: 10),
                    textInput("Height (h)",
                        (v) => param2 = double.tryParse(v) ?? 0),
                  ],

                  if (selectedShape == "Trapezoid") ...[
                    textInput("Base A (a)",
                        (v) => param1 = double.tryParse(v) ?? 0),
                    const SizedBox(height: 10),
                    textInput("Base B (b)",
                        (v) => param2 = double.tryParse(v) ?? 0),
                    const SizedBox(height: 10),
                    textInput("Height (h)",
                        (v) => param3 = double.tryParse(v) ?? 0),
                  ],

                  const SizedBox(height: 20),

                  if (selectedShape.isNotEmpty)
                    ElevatedButton(
                      onPressed: calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Center(
                        child: Text("Calculate",
                            style: TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                    ),

                  const SizedBox(height: 20),

                  if (result.isNotEmpty)
                    Text(
                      result,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- SHAPE BUTTON UI ---
  Widget shapeButton(String name, IconData icon, String formula) {
    return GestureDetector(
      onTap: () => selectShape(name, formula),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.orangeAccent),
            const SizedBox(height: 5),
            Text(name, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget textInput(String label, Function(String) onChange) {
    return TextField(
      onChanged: onChange,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent),
        ),
      ),
    );
  }
}

class MathBackgroundPainter extends CustomPainter {
  final List<String> symbols = ["+", "-", "×", "÷", "√", "π"];
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 40; i++) {
      String sym = symbols[random.nextInt(symbols.length)];

      textPainter.text = TextSpan(
        text: sym,
        style: TextStyle(
          fontSize: 40,
          color: Colors.white.withOpacity(0.04),
        ),
      );

      textPainter.layout();

      double dx = random.nextDouble() * size.width;
      double dy = random.nextDouble() * size.height;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(random.nextDouble() * pi / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
