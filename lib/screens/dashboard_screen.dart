import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../services/ai_schedule_services.dart';
import '../models/task_model.dart';
import 'task_input_screen.dart';
import 'recommendation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // These listeners will now work correctly because we fixed the getters in the service
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final aiService = Provider.of<AiScheduleServices>(context);

    final sortedTasks = List<TaskModel>.from(scheduleProvider.tasks);
    sortedTasks.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Resolver'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // This now correctly checks the public getter 'currentAnalysis'
            if (aiService.currentAnalysis != null)
              Card(
                color: Colors.green.shade100,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        children: [
                          const Text('🎉 Recommendation Ready!',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RecommendationScreen())
                              ),
                              child: const Text('View Recommendations')
                          )
                        ]
                    )
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: sortedTasks.isEmpty
                  ? const Center(child: Text('No tasks added yet!'))
                  : ListView.builder(
                itemCount: sortedTasks.length,
                itemBuilder: (context, index) {
                  final task = sortedTasks[index];
                  // Formatting the time for better display
                  final String timeString = "${task.startTime.hour.toString().padLeft(2, '0')}:${task.startTime.minute.toString().padLeft(2, '0')}";

                  return Card(
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text("${task.category} | $timeString"),
                      trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => scheduleProvider.removeTask(task.id)
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (sortedTasks.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // aiService.isLoading is now a valid boolean from your service getter
                  onPressed: aiService.isLoading
                      ? null
                      : () => aiService.analyzeSchedule(scheduleProvider.tasks),
                  child: aiService.isLoading
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                  )
                      : const Text('Resolve Conflicts With AI'),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskInputScreen())
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}