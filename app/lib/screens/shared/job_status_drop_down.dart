import 'package:app/@core/services/job_service.dart';
import 'package:flutter/material.dart';

class JobStatusDropDown extends StatefulWidget {
  const JobStatusDropDown({Key? key, required this.id, required this.status})
      : super(key: key);

  final String id;
  final String? status;

  @override
  _JobStatusDropDownState createState() => _JobStatusDropDownState();
}

class _JobStatusDropDownState extends State<JobStatusDropDown> {
  late String? dropdownValue = widget.status == "" ? null : widget.status;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      hint: Text('STATUS'),
      onChanged: (String? newValue) async {
        await JobService.updateStatus(id: widget.id, status: newValue!)
            .then((_) => setState(() {
                  dropdownValue = newValue;
                }));
      },
      items: <String>['In progress', 'Complete']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
