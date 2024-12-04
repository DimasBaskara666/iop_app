// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/sensor_data.dart';

// class SupabaseService {
//   final _client = Supabase.instance.client;

//   // Fetch data from Supabase
//   Future<List<SensorData>> fetchSensorData() async {
//     final response = await _client
//         .from('sensors')
//         .select()
//         .order('created_at', ascending: false)
//         .limit(10)
//         .get();

//     if (response.error != null) {
//       throw Exception(
//           'Failed to fetch sensor data: ${response.error!.message}');
//     }

//     return (response.data as List<dynamic>)
//         .map((json) => SensorData.fromJson(json))
//         .toList();
//   }

//   // Update door lock status
//   Future<void> toggleDoorLock(String id, bool currentStatus) async {
//     final response = await _client
//         .from('sensors')
//         .update({'door_locked': !currentStatus})
//         .eq('id', id)
//         .execute();

//     if (response.error != null) {
//       throw Exception(
//           'Failed to update door lock status: ${response.error!.message}');
//     }
//   }

//   // Update lamp status
//   Future<void> toggleLamp(String id, bool currentStatus) async {
//     final response = await _client
//         .from('sensors')
//         .update({'lamp_on': !currentStatus})
//         .eq('id', id)
//         .execute();

//     if (response.error != null) {
//       throw Exception(
//           'Failed to update lamp status: ${response.error!.message}');
//     }
//   }
// }
