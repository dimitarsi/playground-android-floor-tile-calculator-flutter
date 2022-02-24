import 'package:floot_calculator_flutter/components/custom_drawer.dart';
import 'package:floot_calculator_flutter/models/measurement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatefulWidget {
  Future<List<Measurement>> data;

  ProjectsPage({key, required this.data}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() {
    return ProjectsPageState(data: data);
  }
}

class ProjectsPageState extends State<ProjectsPage> {
  List<Measurement> data = [];
  bool loading = true;

  ProjectsPageState({required Future<List<Measurement>> data}) {
    data.then((resp) {
      setState(() {
        this.data = resp;
        loading = false;
      });
    }).catchError((param1, param2) {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
      appBar: AppBar(),
      drawer: CustomDrawer(
        key: const Key("projects"),
        currentPage: "/projects",
      ),
    );
  }

  Widget body(context) {
    if (loading) {
      return Column(
        children: [CircularProgressIndicator()],
      );
    }

    if (data.length == 0) {
      return Center(
        child: Column(
          children: [
            Text("No projects found"),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, "calculator"),
                child: Text("Create a new Project"))
          ],
        ),
      );
    }

    return Column(children: [
      SizedBox(
        height: 80,
      ),
      Expanded(
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Row(
                  children: [
                    Text("${data[i].roomWidth} x ${data[i].roomWidth}")
                  ],
                );
              }))
    ]);
  }
}
