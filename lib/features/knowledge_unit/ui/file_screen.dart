import 'dart:io';
import 'package:bond/features/knowledge_base/models/knowledge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bond/config/constant.dart';
import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_bloc.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_event.dart';
import 'package:bond/features/knowledge_unit/bloc/unit_state.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class FileScreen extends StatefulWidget {
  final Knowledge knowledge;

  const FileScreen({super.key, required this.knowledge});

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? selectedFile;
  String fileName = '';

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt'
      ],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    }
  }

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
          title: const Text('Local Files'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                fileName = '';
              });
              context.go('/create-bot');
            },
          ),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: secondaryColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Image.asset(localFileImagePath, width: 50, height: 50),
                        const SizedBox(width: 10),
                        const Text('Local Files'),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _launchURL(context),
                      icon: const Icon(Icons.link, color: primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: selectFile,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 50, color: primaryColor),
                        SizedBox(height: 10),
                        Text("Click here to upload files",
                            style: TextStyle(color: primaryColor)),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Support for a single or bulk. Strictly prohibit from uploading company data or other band files",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (fileName.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.attach_file, color: primaryColor),
                      const SizedBox(width: 4),
                      Text(fileName,
                          style: const TextStyle(color: primaryColor)),
                    ],
                  ),
                const SizedBox(height: 10),
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
                      onPressed: (state is UnitLoading || selectedFile == null)
                          ? null
                          : () {
                              if (selectedFile == null) {
                                return;
                              }
                              // final extension = selectedFile!.path.split('.').last.toLowerCase();
                              // final mediaType = MediaType.parse('application/$extension');
                              context.read<UnitBloc>().add(UploadLocalFileEvent(
                                  widget.knowledge, selectedFile!));
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
    );
  }
}
