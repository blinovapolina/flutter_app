import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Создание отчета',
      home: ReportCreationScreen(),
    );
  }
}

class ReportCreationScreen extends StatefulWidget {
  const ReportCreationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportCreationScreenState createState() => _ReportCreationScreenState();
}

class _ReportCreationScreenState extends State<ReportCreationScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  int? _rating;
  final maxDescriptionLength = 500;
  late String currentUnixTime;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    // Формат UNIX
    currentUnixTime =
        (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
    // Формат обычный
    formattedDate = (DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание отчета'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле ввода для описания
            TextField(
              controller: _descriptionController,
              maxLength: maxDescriptionLength,
              decoration: InputDecoration(
                labelText: 'Описание (до $maxDescriptionLength символов)',
                border: const OutlineInputBorder(),
              ),
              maxLines: 5, // Многострочное поле
            ),

            const SizedBox(height: 16),
            // Выпадающий список для выбора оценки
            DropdownButton<int>(
              hint: const Text('Выберите оценку'),
              value: _rating,
              items: List.generate(10, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1}'),
                );
              }),
              onChanged: (newValue) {
                setState(() {
                  _rating = newValue;
                });
              },
            ),

            const SizedBox(height: 16),
            // Текущая дата в формате UNIX
            Text('Текущая дата в формате UNIX: $currentUnixTime'),

            const SizedBox(height: 16),
            // Текущая дата в обычном формате
            Text('Текущая дата: $formattedDate'),

            const SizedBox(height: 16),
            // Кнопка для отправки
            ElevatedButton(
              onPressed: () async {
                String description = _descriptionController.text;
                if (description.isEmpty || _rating == null) {
                  // Вывод ошибки, если поле пустое или оценка не выбрана
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Пожалуйста, заполните все поля.')),
                  );
                } else {
                  // Вывод информации в консоль
                  print('Описание: $description');
                  print('Оценка: $_rating');
                  print('Текущая дата в формате UNIX: $currentUnixTime');
                  print('Текущая дата: $formattedDate');

                  // Очистка полей после отправки
                  _descriptionController.clear();
                  setState(() {
                    _rating = null;
                  });

                  // Сообщение об успешной отправке
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Отчет успешно создан!')),
                  );
                }
              },
              child: const Text('Создать отчет'),
            ),
          ],
        ),
      ),
    );
  }
}
