import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone_contacts/data/models/models.dart';
import 'package:timezone_contacts/data/repositories/repository.dart';
import 'package:timezone_contacts/ui/screens/screens.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  const ContactFormScreen({
    super.key,
    this.contact,
  });

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool editMode = false;

  File? avatar;

  @override
  void initState() {
    if (widget.contact != null) {
      editMode = true;

      if (widget.contact!.image != null && widget.contact!.image!.isNotEmpty) {
        avatar = File(widget.contact!.image!);
      }
    }

    super.initState();
  }

  Future<String?> saveImage(String? imagePath) async {
    if (widget.contact != null && imagePath == widget.contact!.image) {
      return widget.contact!.image;
    }

    String? finalImagePath;

    if (imagePath != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = basename(imagePath);
      final image = File('${dir.path}/$fileName');

      final imageFile = await File(imagePath).copy(image.path);

      finalImagePath = imageFile.path;
    }

    return finalImagePath;
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<Repository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(editMode ? 'Edit Contact' : 'New Contact'),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final formValues = _formKey.currentState!.value;

                    saveImage(formValues['image']).then(
                      (finalImagePath) {
                        if (widget.contact == null) {
                          final newContact = Contact(
                            name: formValues['name'],
                            timezone: formValues['timezone'],
                            image: finalImagePath,
                          );

                          repository.addContact(newContact);
                        } else {
                          final updatedContact = Contact(
                            id: widget.contact!.id,
                            name: formValues['name'],
                            timezone: formValues['timezone'],
                            image: finalImagePath,
                          );

                          repository.updateContact(updatedContact);
                        }

                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  }
                },
                child: const Icon(
                  Icons.check,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  FormBuilderField<String?>(
                    name: 'image',
                    initialValue: widget.contact?.image,
                    validator: (value) {
                      return null;
                    },
                    builder: (FormFieldState<dynamic> field) {
                      return GestureDetector(
                        onTap: () async {
                          ImageSource? imageSource =
                              await showDialog<ImageSource?>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Select Source'),
                              content: const Text(
                                  'Where do you want to pick the image from?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(
                                      context, ImageSource.camera),
                                  child: const Text('Camera'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(
                                      context, ImageSource.gallery),
                                  child: const Text('Gallery'),
                                ),
                              ],
                            ),
                          );

                          if (imageSource == null) {
                            return;
                          }

                          final image = await ImagePicker()
                              .pickImage(source: imageSource);

                          if (image == null) return;

                          final imageTemporary = File(image.path);

                          field.didChange(image.path);

                          setState(() {
                            avatar = imageTemporary;
                          });
                        },
                        child: (avatar != null)
                            ? CircleAvatar(
                                backgroundImage: Image.file(
                                  avatar!,
                                  fit: BoxFit.cover,
                                ).image,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.photo_camera),
                              ),
                      );
                    },
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'name',
                      initialValue: widget.contact?.name ?? '',
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      valueTransformer: (value) {
                        if (value != null) {
                          return value.trim();
                        }
                        return value;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              FormBuilderField<String>(
                name: 'timezone',
                initialValue: widget.contact?.timezone ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the time zone.';
                  }
                  return null;
                },
                builder: (FormFieldState<dynamic> field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        labelText: 'Time Zone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorText: (field.value == null)
                            ? 'Please select time zone'
                            : null),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimezoneSelectScreen(
                              onSelect: (value) {
                                field.didChange(value);
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(field.value ?? 'Not set'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
