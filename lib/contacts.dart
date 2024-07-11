import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Contacts List')),
        backgroundColor: Colors.yellow.shade800,
      ),
      body: Container(
        height: double.infinity,
        child: FutureBuilder(
          future: getContacts(),
          builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No contacts found or permission denied'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Contact contact = snapshot.data![index];
                String phone = contact.phones.isNotEmpty ? contact.phones[0].number : 'No phone number';
                String email = contact.emails.isNotEmpty ? contact.emails[0].address : 'No email';

                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                  title: Text(contact.displayName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(phone),
                      Text(email),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Future<List<Contact>> getContacts() async {
  var status = await Permission.contacts.status;
  if (!status.isGranted) {
    status = await Permission.contacts.request();
  }

  if (status.isGranted) {
    return await FastContacts.getAllContacts();
  } else {
    return [];
  }
}
