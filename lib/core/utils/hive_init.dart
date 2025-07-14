import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import '../../data/models/employee_model.dart';

class HiveInit {
  static const String employeesBoxName = 'employees';

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(EmployeeModelAdapter());
    
    // Open boxes
    await Hive.openBox<EmployeeModel>(employeesBoxName);
  }

  static Future<void> close() async {
    await Hive.close();
  }
} 