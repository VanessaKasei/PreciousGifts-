import 'package:precious_gifts/imports/import.dart';

class aboutus extends StatefulWidget {
  const aboutus({super.key});

  @override
  State<aboutus> createState() => _aboutusState();
}

class _aboutusState extends State<aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About us ')),
      body: const Text(
          'Precious Gifts is a donation application that allows donors to make donations easily.\n Your donation are highly appreciated regardless of the quantity.\n 2nd Corinthians 9: 6- 8 "Each of you should give what you have decided in your heart to give,\n not reluctantly or under compulsion, for God loves a cheerful giver.\n And God is able to bless you abundantly, so that in all things at all times, having all that you need,\n you will abound in every good work."'),
    );
  }
}
