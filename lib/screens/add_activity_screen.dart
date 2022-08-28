import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_tymes/constants/custom_exception.dart';
import 'package:good_tymes/models/address.dart';
import 'package:good_tymes/models/category.dart';
import 'package:good_tymes/screens/home_screen.dart';
import 'package:good_tymes/screens/map_screen.dart';
import 'package:good_tymes/services/activities_services.dart';
import 'package:intl/intl.dart';
import 'package:good_tymes/components/form_field_title.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/theme/theme_data.dart';

class AddActivityScreen extends StatefulWidget {
  static const routeName = '/add-activity';

  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSubmitting = false;

  // Text Editing Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  // Category;
  String? _category;
  Future<void> _getCategories() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2), () {});
    // // Obtain Categories from Firebase
    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection('categories/${widget.categoryUid}/subcategories')
    //     .get();
    // final allData = querySnapshot.docs.map((doc) => doc.get('name')).toList();
    // for (int i = 0; i < allData.length; i++) {
    //   setState(() {
    //     _categories.add(allData[i]);
    //   });
    // }
    setState(() {
      _isLoading = false;
    });
  }

  // Date and Time
  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _timeFormat = DateFormat("HH:mm");

  // Address
  Address _address = Address(
    displayName: 'Default Address',
    latitude: 0,
    longitude: 0,
  );
  void _setAddress(Address address) {
    setState(() {
      _locationController.text = address.displayName;
      _address = address;
    });
  }

  // Submit Form
  void _submit() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      _isSubmitting = true;
    });
    try {
      if (_nameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _category == null ||
          _address.displayName.isEmpty ||
          _address.latitude == 0 ||
          _address.longitude == 0 ||
          _dateController.text.isEmpty ||
          _timeController.text.isEmpty ||
          _numberController.text.isEmpty) {
        throw CustomException(getText(context).invalidFields);
      } else {
        // print(_nameController.text);
        // print(_descriptionController.text);
        // print(_category);
        // print(_address);
        // print(_dateController.text);
        // print(_timeController.text);
        // print(_numberController.text);

        final res = await ActivitiesServices().addNewActivity(
          context: context,
          name: _nameController.text,
          description: _descriptionController.text,
          category: _category!,
          date: _dateController.text,
          time: _timeController.text,
          address: _address,
          limit: int.parse(_numberController.text),
        );
        _showDialog(res);
      }
    } on CustomException catch (ce) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ce.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      //print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getText(context).somethingWentWrong),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
    setState(() {
      _isSubmitting = false;
    });
  }

  // Show Dialog Upon submission
  Future<void> _showDialog(String res) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(getText(context).submission),
          content: Text(res),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, getText(context).ok);
                Navigator.pushReplacementNamed(
                  context,
                  HomeScreen.routeName,
                );
              },
              child: Text(getText(context).ok),
            ),
          ],
        );
      },
    );
  }

  // Close form confirmation
  void _closeForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(getText(context).leaveFormTitle),
          content: Text(getText(context).leaveFormWarning),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog box
              },
              child: Text(
                getText(context).no,
                style: const TextStyle(color: Colors.blueAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog box
                Navigator.of(context).pop(); // Close form
              },
              child: Text(
                getText(context).yes,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
    _numberController.text = "0";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getText(context).createNewActivity),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _closeForm(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: _isSubmitting
            ? null
            : InkWell(
                onTap: () async {
                  _submit();
                },
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Center(
                    child: Text(
                      getText(context).submit,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _form,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      // Name
                      FormFieldTitle(
                        title: getText(context).activityName,
                        hint: getText(context).activityNameHint,
                        iconData: Icons.title,
                      ),
                      TextFormField(
                        maxLength: 50,
                        decoration: getInputDecoration(
                            null, getText(context).typeHere, null),
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getText(context).fieldCannotBeEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Description
                      FormFieldTitle(
                        title: getText(context).activityDescription,
                        hint: getText(context).activityDescriptionHint,
                        iconData: Icons.description,
                      ),
                      TextFormField(
                        maxLength: 300,
                        minLines: 4,
                        maxLines: 10,
                        decoration: getInputDecoration(
                            null, getText(context).typeHere, null),
                        controller: _descriptionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getText(context).fieldCannotBeEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Category
                      FormFieldTitle(
                        title: getText(context).activityCategory,
                        hint: getText(context).activityCategoryHint,
                        iconData: Icons.category,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: DropdownButton<String>(
                          value: _category,
                          style: const TextStyle(color: Colors.black),
                          items:
                              categories.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              enabled: (value.name != "sep"),
                              value: value.name,
                              child: value.name != "sep"
                                  ? Text(value.name)
                                  : Text(
                                      value.type,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          }).toList(),
                          hint: Text(
                            getText(context).activityCategoryHint,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _category = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Date
                      FormFieldTitle(
                        title: getText(context).date,
                        hint: getText(context).dateHint,
                        iconData: Icons.calendar_month,
                      ),
                      DateTimeField(
                        controller: _dateController,
                        format: _dateFormat,
                        decoration: getInputDecoration(
                            null, getText(context).clickMe, null),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            helpText: getText(context).dateHint,
                            confirmText: getText(context).ok,
                            cancelText: getText(context).cancel,
                            fieldLabelText: getText(context).date,
                            fieldHintText: getText(context).dateHint,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                        },
                      ),
                      const SizedBox(height: 30),

                      // Time
                      FormFieldTitle(
                        title: getText(context).time,
                        hint: getText(context).timeHint,
                        iconData: Icons.timer,
                      ),
                      DateTimeField(
                        controller: _timeController,
                        format: _timeFormat,
                        decoration: getInputDecoration(
                            null, getText(context).clickMe, null),
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            helpText: getText(context).timeHint,
                            confirmText: getText(context).ok,
                            cancelText: getText(context).cancel,
                            hourLabelText: getText(context).hour,
                            minuteLabelText: getText(context).minute,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                      ),
                      const SizedBox(height: 30),

                      // Location
                      FormFieldTitle(
                        title: getText(context).activityLocation,
                        hint: getText(context).activityLocationHint,
                        iconData: Icons.location_pin,
                      ),
                      TextFormField(
                        maxLength: 200,
                        minLines: 1,
                        maxLines: 5,
                        decoration: getInputDecoration(
                            null, getText(context).typeHere, null),
                        controller: _locationController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getText(context).fieldCannotBeEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                        Text(getText(context).or),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                setAddress: _setAddress,
                                initialAddress: _address,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.map_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                          getText(context).openMaps,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Limit Participants
                      FormFieldTitle(
                        title: getText(context).limitParticipants,
                        hint: getText(context).limitParticipantsHint,
                        iconData: Icons.group,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              decoration: getInputDecoration(
                                  null, getText(context).clickMe, null),
                              controller: _numberController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: false,
                                signed: true,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 38.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: InkWell(
                                    child: const Icon(
                                      Icons.arrow_drop_up,
                                      size: 18.0,
                                    ),
                                    onTap: () {
                                      int currentValue =
                                          int.parse(_numberController.text);
                                      setState(() {
                                        currentValue++;
                                        _numberController.text = (currentValue)
                                            .toString(); // incrementing value
                                      });
                                    },
                                  ),
                                ),
                                InkWell(
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    size: 18.0,
                                  ),
                                  onTap: () {
                                    int currentValue =
                                        int.parse(_numberController.text);
                                    setState(() {
                                      currentValue--;
                                      _numberController.text =
                                          (currentValue > 0 ? currentValue : 0)
                                              .toString(); // decrementing value
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
