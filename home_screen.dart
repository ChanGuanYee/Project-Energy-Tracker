import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appliance_provider.dart';
import 'add_appliance_screen.dart';
import 'ai_tip_detail_screen.dart';
import 'auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplianceProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Tracker',style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
            await AuthService().signOut();
          },
        ),
      ],
    ),
body: Consumer<ApplianceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.amber[50],
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monthly Usage (30 Days):', style: TextStyle(fontSize: 16)),
                        Text('${provider.totalMonthlyKwh.toStringAsFixed(2)} kWh', 
                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Est. TNB Bill:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('RM ${provider.estimatedMonthlyCostRM.toStringAsFixed(2)}', 
                             style: const TextStyle(fontSize: 22, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AiTipDetailScreen(shortTip: provider.randomTip),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: Colors.green, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          provider.randomTip, 
                          style: const TextStyle(
                            fontSize: 14, 
                            color: Colors.green, 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      const Icon(Icons.auto_awesome, color: Colors.amber), 
                    ],
                  ),
                ),
              ),

              Expanded(
                child: provider.appliances.isEmpty
                    ? const Center(
                        child: Text(
                          'No appliances added yet.\nTap + to start tracking.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.appliances.length,
                        itemBuilder: (context, index) {
                          final app = provider.appliances[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: const Icon(Icons.electrical_services, color: Colors.amber),
                              title: Text(app.name),
                              subtitle: Text('${app.powerWatts}W | ${app.hoursUsedPerDay} hrs/day'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddApplianceScreen(appliance: app),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: Text('Are you sure you want to remove ${app.name}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                provider.deleteAppliance(app.id);
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddApplianceScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}