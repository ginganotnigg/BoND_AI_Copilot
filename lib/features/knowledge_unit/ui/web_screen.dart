import 'package:bond/features/knowledge_base/models/knowledge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/config/constant.dart';
import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_bloc.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_event.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_state.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class WebScreen extends StatelessWidget {
  final Knowledge knowledge;

  WebScreen({super.key, required this.knowledge});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController webUrlController = TextEditingController();

  Future<void> _launchURL(BuildContext context) async {
    final Uri url =
        Uri.parse('https://jarvis.cx/help/knowledge-base/connectors/');
    try {
      if (!await canLaunchUrl(url)) {
        throw 'URL is invalid: $url';
      }
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error when opened URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UnitBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Web'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/assistant');
            },
          ),
        ),
        body: Form(
          key: formKey,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: secondaryColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Image.asset(webImagePath, width: 50, height: 50),
                            const SizedBox(width: 10),
                            const Text('Web'),
                          ],
                        ),
                        IconButton(
                          onPressed: () => _launchURL(context),
                          icon: const Icon(Icons.link,
                              color: primaryColor, size: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Divider(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter Name',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: webUrlController,
                        style: const TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                          labelText: 'Web URL',
                          hintText: 'Enter Web URL',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Web URL';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<UnitBloc, UnitState>(
                      listener: (context, state) {
                        if (state is UnitLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Knowledge updated!')),
                          );
                          Navigator.pop(context);
                        } else if (state is UnitError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          style: filled,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            final unitName = nameController.text;
                            final webUrl = webUrlController.text;
                            context.read<UnitBloc>().add(
                                UploadWebEvent(knowledge, unitName, webUrl));
                            context.go('/assistant');
                          },
                          child: (state is UnitLoading)
                              ? const Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text("Uploading..."),
                                    Positioned(
                                      child: CupertinoActivityIndicator(
                                        radius: 10,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                )
                              : const Text('Connect',
                                  style: TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
