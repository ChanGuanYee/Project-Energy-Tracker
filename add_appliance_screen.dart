import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appliance.dart';
import 'appliance_provider.dart';

class AddApplianceScreen extends StatefulWidget {
  final Appliance? appliance;

  const AddApplianceScreen({super.key, this.appliance});

  @override
  State<AddApplianceScreen> createState() => _AddApplianceScreenState();
}

class _AddApplianceScreenState extends State<AddApplianceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _powerWatts;
  late double _hours;

  bool get isEditing => widget.appliance != null;

  @override
  void initState() {
    super.initState();
    _name = widget.appliance?.name ?? '';
    _powerWatts = widget.appliance?.powerWatts ?? 0;
    _hours = widget.appliance?.hoursUsedPerDay ?? 0;
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<ApplianceProvider>(context, listen: false);

      if (isEditing) {
        final updated = widget.appliance!.copyWith(
          name: _name,
          powerWatts: _powerWatts,
          hoursUsedPerDay: _hours,
        );
        provider.updateAppliance(updated);
      } else {
        final newAppliance = Appliance(
          id: DateTime.now().toString(),
          name: _name,
          powerWatts: _powerWatts,
          hoursUsedPerDay: _hours,
        );
        provider.addAppliance(newAppliance);
      }
          
      Navigator.pop(context);
    }
  }

  InputDecoration _inputStyle(String label, IconData icon, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.amber),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.amber.shade500, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Appliance' : 'Add New Appliance',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isEditing ? Icons.edit_note_rounded : Icons.add_chart_rounded,
                    size: 60,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              const Text(
                'Device Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _name,
                decoration: _inputStyle('Appliance Name', Icons.devices_other, 'e.g. Air Conditioner'),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter device name' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: isEditing ? _powerWatts.toString() : '',
                decoration: _inputStyle('Power Consumption', Icons.bolt, 'Watts (W)'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  final n = double.tryParse(val ?? '');
                  if (n == null) return 'Please enter a valid number';
                  return null;
                },
                onSaved: (val) => _powerWatts = double.parse(val!),
              ),
              const SizedBox(height: 20),

              TextFormField(
                initialValue: isEditing ? _hours.toString() : '',
                decoration: _inputStyle('Usage Hours', Icons.timer_outlined, 'Hours per day'),
                keyboardType: TextInputType.number,
                validator: (val) {
                  final n = double.tryParse(val ?? '');
                  if (n == null) return 'Please enter a valid number';
                  if (n > 24) return 'Maximum 24 hours';
                  return null;
                },
                onSaved: (val) => _hours = double.parse(val!),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  isEditing ? 'Update Changes' : 'Save Appliance',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              
              if (isEditing) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}