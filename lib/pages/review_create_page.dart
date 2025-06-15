import 'package:album_reviews_app/models/Model.dart';
import 'package:flutter/material.dart';
import '../widgets/site_scaffold.dart';
import '../services/api_manager.dart';

class ReviewCreatePage extends StatefulWidget {
  const ReviewCreatePage({Key? key}) : super(key: key);

  @override
  State<ReviewCreatePage> createState() => _ReviewCreatePageState();
}

class _ReviewCreatePageState extends State<ReviewCreatePage> {
  final _formKey = GlobalKey<FormState>();
  int? _albumId;
  int _rating = 3;
  String _comment = '';
  bool _submitting = false;
  String? _error;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _submitting = true);
    try {
      await Model().creaRecensione(
        albumId: _albumId!,
        rating: _rating,
        comment: _comment,
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SiteScaffold(
      currentRouteName: '/reviews/new',
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ID Album'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  v == null || int.tryParse(v) == null ? 'ID non valido' : null,
                  onSaved: (v) => _albumId = int.parse(v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Rating'),
                  value: _rating,
                  items: List.generate(
                    5,
                        (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1} ★'),
                    ),
                  ),
                  onChanged: (v) => setState(() => _rating = v!),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Commento'),
                  maxLines: 4,
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci un commento' : null,
                  onSaved: (v) => _comment = v!.trim(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const CircularProgressIndicator()
                      : const Text('Invia Recensione'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
