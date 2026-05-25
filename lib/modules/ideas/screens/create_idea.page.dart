import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/title_field_card.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/problem_statement_card.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/proposed_solution_card.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/tags_section.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/visibility_section.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/create_idea_actions.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/collaborators_section.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/attachments_section.dart';
import 'package:jigyasa/modules/ideas/widgets/create_idea/visibility_option.dart';
import 'package:jigyasa/modules/ideas/cubit/ideas_cubit.dart';
import 'package:jigyasa/modules/ideas/cubit/ideas_state.dart';
import 'package:jigyasa/services/upload/file_upload.service.dart';
import 'package:file_picker/file_picker.dart';

class CreateIdeaPage extends StatefulWidget {
  const CreateIdeaPage({super.key});

  @override
  State<CreateIdeaPage> createState() => _CreateIdeaPageState();
}

class _CreateIdeaPageState extends State<CreateIdeaPage> {
  final _formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final problem = TextEditingController();
  final solution = TextEditingController();

  List<String> tags = <String>[];
  VisibilityOption visibility = VisibilityOption.private;
  final List<Map<String, String>> attachments = <Map<String, String>>[]; // {url, filename}

  bool get _hasAnyInput {
    return title.text.trim().isNotEmpty ||
        problem.text.trim().isNotEmpty ||
        solution.text.trim().isNotEmpty ||
        tags.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    for (final c in [title, problem, solution]) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    title.dispose();
    problem.dispose();
    solution.dispose();
    super.dispose();
  }

  void onPreview() {
    if (!_hasAnyInput) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(title.text.trim(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (problem.text.trim().isNotEmpty) Text(problem.text.trim()),
              const SizedBox(height: 8),
              if (solution.text.trim().isNotEmpty) Text(solution.text.trim()),
              const SizedBox(height: 12),
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((t) => Chip(label: Text(t))).toList(),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onCreate() {
    if (!_formKey.currentState!.validate()) return;
    final p = problem.text.trim();
    final s = solution.text.trim();
    if (p.length < 10 || s.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Problem and Solution must be at least 10 characters.')),
      );
      return;
    }
    final vis = visibility.name.toUpperCase();
    String? imageUrl;
    for (final a in attachments) {
      final u = a['url'];
      if (u != null && u.isNotEmpty) {
        imageUrl = u;
        break;
      }
    }

    final payload = <String, dynamic>{
      'title': title.text.trim(),
      // Provide both naming variants to satisfy server DTO expectations
      'problem': p,
      'problemStatement': p,
      'solution': s,
      'proposedSolution': s,
      if (tags.isNotEmpty) 'tags': tags,
      'visibility': vis,
      if (attachments.isNotEmpty) 'attachments': attachments,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
    context.read<IdeasCubit>().createIdea(payload);
  }

  Future<void> _pickFileAndUpload({required bool image}) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: image ? FileType.image : FileType.any,
    );
    if (result == null || result.files.isEmpty) return;
    final f = result.files.first;
    final path = f.path;
    if (path == null || path.isEmpty) return;
    final ext = (f.extension ?? '').toLowerCase();
    String contentType = 'application/octet-stream';
    if (image) {
      if (ext == 'png') contentType = 'image/png';
      else if (ext == 'jpg' || ext == 'jpeg') contentType = 'image/jpeg';
      else if (ext == 'gif') contentType = 'image/gif';
      else if (ext == 'webp') contentType = 'image/webp';
      else contentType = 'image/*';
    } else {
      if (ext == 'png') contentType = 'image/png';
      else if (ext == 'jpg' || ext == 'jpeg') contentType = 'image/jpeg';
      else if (ext == 'gif') contentType = 'image/gif';
      else if (ext == 'webp') contentType = 'image/webp';
      else if (ext == 'pdf') contentType = 'application/pdf';
      else if (ext == 'txt') contentType = 'text/plain';
      else if (ext == 'csv') contentType = 'text/csv';
      else if (ext == 'doc') contentType = 'application/msword';
      else if (ext == 'docx') contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      else if (ext == 'pptx') contentType = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      else if (ext == 'xlsx') contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }

    final uploader = FileUploadService();
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading...')));
      final res = await uploader.uploadWithPresignedPutFilePath(
        path: path,
        contentType: contentType,

        signExtra: const {'folder': 'ideas/attachments'},
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload complete')));
      if (res.url != null && res.url!.isNotEmpty) {
        setState(() {
          attachments.add({'url': res.url!, 'filename': res.filename});
        });
      } else {
        setState(() {
          attachments.add({'url': '', 'filename': res.filename});
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create your Innovation')),
      body: SafeArea(
        child: BlocListener<IdeasCubit, IdeasState>(
          listener: (context, state) {
            if (state is IdeaCreateLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Creating idea...')),
              );
            } else if (state is IdeaCreateSuccess) {
              // If this page is inside a tab (IndexedStack), popping can cause a black screen.
              // Only pop if there's something to pop, otherwise reset the form and stay.
              if (Navigator.of(context).canPop()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Idea created successfully')),
                );
                Navigator.of(context).pop(true);
              } else {
                // Reset form content
                title.clear();
                problem.clear();
                solution.clear();
                setState(() {
                  tags.clear();
                  attachments.clear();
                  visibility = VisibilityOption.private;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Idea created successfully')),
                );
              }
            } else if (state is IdeaCreateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to create: ${state.message}')),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TitleFieldCard(controller: title),
                const SizedBox(height: 12),
                ProblemStatementCard(controller: problem),
                const SizedBox(height: 12),
                ProposedSolutionCard(controller: solution),
                const SizedBox(height: 12),
                TagsSection(
                  tags: tags,
                  onAdd: (t) {
                    if (t.trim().isEmpty) return;
                    setState(() {
                      if (!tags.contains(t.trim())) tags.add(t.trim());
                    });
                  },
                  onRemove: (t) {
                    setState(() {
                      tags.remove(t);
                    });
                  },
                ),
                const SizedBox(height: 12),
                const CollaboratorsSection(),
                const SizedBox(height: 12),
                AttachmentsSection(
                  onPickImage: () => _pickFileAndUpload(image: true),
                  onPickFile: () => _pickFileAndUpload(image: false),
                  onAddLink: () async {
                    final linkCtrl = TextEditingController();
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Add Link'),
                          content: TextField(
                            controller: linkCtrl,
                            decoration: const InputDecoration(hintText: 'https://...'),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Add')),
                          ],
                        );
                      },
                    );
                    if (ok == true && linkCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        attachments.add({'url': linkCtrl.text.trim(), 'filename': linkCtrl.text.trim()});
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                VisibilitySection(
                  value: visibility,
                  onChanged: (v) {
                    setState(() {
                      visibility = v;
                    });
                  },
                ),
                if (_hasAnyInput) ...[
                  const SizedBox(height: 12),
                  CreateIdeaActions(
                    onPreview: onPreview,
                    onCreate: onCreate,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
