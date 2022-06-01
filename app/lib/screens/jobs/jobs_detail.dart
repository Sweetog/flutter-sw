import 'package:app/@core/models/inlet_model.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/models/location_model.dart';
import 'package:app/@core/models/material_model.dart';
import 'package:app/@core/models/service_model.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/jobs/inlets.dart';
import 'package:flutter/material.dart';

class JobDetails extends StatelessWidget {
  final JobModel jobModel;

  const JobDetails({Key? key, required this.jobModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(jobModel.name)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EachRowWidget(keyName: "Route: ", keyValue: jobModel.route ?? ""),
            EachRowWidget(keyName: "Address: ", keyValue: jobModel.address),
            EachRowWidget(
                keyName: "Name: ", keyValue: jobModel.contact?.name ?? ""),
            EachRowWidget(
                keyName: "Phone: ", keyValue: jobModel.contact?.phone ?? ""),
            EachRowWidget(
                keyName: "Email: ", keyValue: jobModel.contact?.email ?? ""),
            EachRowWidget(
                keyName: "Job Status: ", keyValue: jobModel.status ?? ""),
            Expanded(child: JobInlets(jobModel.id)),
          ],
        ),
      ),
    );
  }
}

class InletWidget extends StatelessWidget {
  final List<InletModel>? inlets;

  const InletWidget({Key? key, this.inlets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inlets != null) {
      if (inlets!.isNotEmpty) {
        return Column(
          children: <Widget>[
            ...inlets!.map((item) {
              return EachInletWidget(
                model: item,
              );
            }).toList(),
          ],
        );
      } else {
        return Text("No inlets ");
      }
    } else {
      return Text("No inlets ");
    }
  }
}

class EachRowWidget extends StatelessWidget {
  const EachRowWidget({Key? key, required this.keyName, required this.keyValue})
      : super(key: key);
  final String keyName;
  final String keyValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            keyName,
            style: UIUtil.getTxtStyleCaption2(),
          ),
          Text(
            keyValue,
            style: UIUtil.getTxtStyleCaption2(),
          ),
        ],
      ),
    );
  }
}

class EachInletWidget extends StatelessWidget {
  final InletModel model;

  const EachInletWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(model.type),
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Image.network(
                        model.beforeImgUrl,
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .2,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Image.network(
                        model.beforeImgUrl,
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .2,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    /*(model.afterImgUrl != null)
                        ? Image.network(
                            model.beforeImgUrl,
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width * .2,
                            fit: BoxFit.fill,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            height: 0,
                          ),*/
                  ],
                ),
              ),
              Text("Material"),
              EachRowWidget(
                  keyName: "Construction: ",
                  keyValue: (model.material?.construction ?? 0).toString()),
              EachRowWidget(
                  keyName: "Gravel: ",
                  keyValue: (model.material?.gravel ?? 0).toString()),
              EachRowWidget(
                  keyName: "Organics: ",
                  keyValue: (model.material?.organics ?? 0).toString()),
              EachRowWidget(
                  keyName: "Other: ",
                  keyValue: (model.material?.other ?? 0).toString()),
              EachRowWidget(
                  keyName: "Silt Sand: ",
                  keyValue: (model.material?.siltSand ?? 0).toString()),
              EachRowWidget(
                  keyName: "Trash: ",
                  keyValue: (model.material?.trash ?? 0).toString()),
              Text("Service"),
              EachRowWidget(
                  keyName: "VolumeUsed: ",
                  keyValue: (model.volumeUsed ?? 0).toString()),
              EachCheckBox(
                keyName: "Clean",
                keyValue: true,
              ),
              EachCheckBox(
                keyName: "Inspect",
                keyValue: true,
              ),
              EachCheckBox(
                keyName: "Media",
                keyValue: true,
              ),
              EachCheckBox(
                keyName: "Repairs",
                keyValue: true,
              )
            ],
          )
        ],
      ),
    );
  }
}

class EachCheckBox extends StatelessWidget {
  final String keyName;
  final bool keyValue;

  const EachCheckBox({Key? key, required this.keyName, required this.keyValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            keyName,
            style: UIUtil.getTxtStyleCaption2(),
          ),
          Checkbox(value: true, onChanged: (_) {})
        ],
      ),
    );
  }
}
