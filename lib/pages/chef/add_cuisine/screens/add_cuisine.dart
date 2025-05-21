import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:only_shef/common/colors/colors.dart';
import 'dart:io';
import '../../../cuisine/models/cuisines.dart';
import '../services/add_cuisine_services.dart';

class AddCuisineScreen extends StatefulWidget {
  final String chefId;
  final Cuisine? cuisine; // Optional cuisine for editing

  const AddCuisineScreen({
    Key? key,
    required this.chefId,
    this.cuisine,
  }) : super(key: key);

  @override
  State<AddCuisineScreen> createState() => _AddCuisineScreenState();
}

class _AddCuisineScreenState extends State<AddCuisineScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _ingredients = [];
  final _ingredientController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedCuisineType;
  final List<String> _cuisineTypes = [
    'Pakistani',
    'Chineese',
    'Mexican',
    'Fast Food',
    'Desserts',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    // If editing, populate the form with existing cuisine data
    if (widget.cuisine != null) {
      _nameController.text = widget.cuisine!.name;
      _priceController.text = widget.cuisine!.price.toString();
      _descriptionController.text = widget.cuisine!.description;
      _selectedCuisineType = widget.cuisine!.cuisineType;
      _ingredients.addAll(widget.cuisine!.ingredients);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.cuisine != null;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEditing ? 'Edit Cuisine' : 'Add New Cuisine',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Picker with animation
                    Hero(
                      tag: 'cuisine_image',
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.primaryColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: _imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(_imageFile!,
                                      fit: BoxFit.cover),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      size: 50,
                                      color: theme.primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Add Cuisine Image',
                                      style: GoogleFonts.poppins(
                                        color: theme.primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Cuisine Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                            Icon(Icons.restaurant, color: theme.primaryColor),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Cuisine Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCuisineType,
                      decoration: InputDecoration(
                        labelText: 'Cuisine Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.primaryColor.withOpacity(0.05),
                        prefixIcon:
                            Icon(Icons.category, color: theme.primaryColor),
                      ),
                      icon: Icon(Icons.arrow_drop_down_rounded,
                          color: theme.primaryColor, size: 32),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      dropdownColor: backgroundColor,
                      items: _cuisineTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: theme.primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCuisineType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a cuisine type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Price Field
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                            Icon(Icons.attach_money, color: theme.primaryColor),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                            Icon(Icons.description, color: theme.primaryColor),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Ingredients Section
                    Text(
                      'Ingredients',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ingredientController,
                            decoration: InputDecoration(
                              labelText: 'Add Ingredient',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: Icon(Icons.add_circle_outline,
                                  color: theme.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _addIngredient,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Add',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _ingredients.asMap().entries.map((entry) {
                        return Chip(
                          label: Text(entry.value),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () => _removeIngredient(entry.key),
                          backgroundColor: secondryColor,
                          labelStyle:
                              GoogleFonts.poppins(color: theme.primaryColor),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_imageFile == null && !isEditing) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an image'),
                              ),
                            );
                            return;
                          }
                          if (_ingredients.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please add at least one ingredient'),
                              ),
                            );
                            return;
                          }

                          // Show loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(height: 16),
                                      Text(
                                        isEditing
                                            ? 'Updating Cuisine...'
                                            : 'Adding Cuisine...',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          final cuisine = Cuisine(
                            id: isEditing
                                ? widget.cuisine!.id
                                : '', // Keep existing ID if editing
                            chefId: widget.chefId,
                            cuisineType: _selectedCuisineType!,
                            name: _nameController.text,
                            ingredients: _ingredients,
                            price: double.parse(_priceController.text),
                            imageUrl: isEditing
                                ? widget.cuisine!.imageUrl
                                : '', // Keep existing image if editing
                            description: _descriptionController.text,
                          );

                          final addCuisineServices = AddCuisineServices();
                          final success = await (isEditing
                              ? addCuisineServices.updateCuisine(
                                  context, cuisine)
                              : addCuisineServices.addCuisine(
                                  context, cuisine));

                          // Close loading dialog
                          Navigator.pop(context);

                          // Show result dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  success ? 'Success' : 'Error',
                                  style: GoogleFonts.poppins(
                                    color: success ? Colors.green : Colors.red,
                                  ),
                                ),
                                content: Text(
                                  success
                                      ? isEditing
                                          ? 'Cuisine updated successfully!'
                                          : 'Cuisine added successfully!'
                                      : 'Failed to ${isEditing ? 'update' : 'add'} cuisine. Please try again.',
                                  style: GoogleFonts.poppins(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      if (success) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      'OK',
                                      style: GoogleFonts.poppins(
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        isEditing ? 'Update Cuisine' : 'Add Cuisine',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
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

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }
}
