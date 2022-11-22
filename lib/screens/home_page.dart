import 'package:doctor_appointment/screens/item_details_page.dart';
import 'package:doctor_appointment/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../context/auth_con.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategories = 'Surgeon';
  // String userName = '';
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     userName = context.read<AuthContext>
  //   });
  // }

  void setSelectedCat(String s) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      selectedCategories = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: initWidget(context),
        ),
      ),
    );
  }

  Widget initWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: buildAppBar(),
          margin: const EdgeInsets.only(top: 15),
        ),
        buildGreetings(context),
        buildSearch(),
        buildCategories(),
        buildDoctorsList()
      ],
    );
  }

  Widget profileWid() {
    if (context.watch<AuthContext>().user.photoUrl != '') {
      return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Profile()));
        },
        child: CircleAvatar(
          backgroundImage: Image.network(
                  'http://192.168.1.3/wp/bucket/images/' +
                      context.watch<AuthContext>().user.photoUrl)
              .image,
        ),
      );
    }
    return InkWell(
      onTap: (() => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Profile()))
          }),
      child: const Icon(
        Icons.account_circle,
        size: 50,
        color: Colors.grey,
      ),
    );
  }

  Widget buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(left: 20),
            child: InkWell(child: profileWid())),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.grey[50],
              border: Border.all(color: Colors.grey, width: 0.3)),
          margin: const EdgeInsets.only(right: 20),
          child: SvgPicture.asset("assets/ic_notification.svg"),
        )
      ],
    );
  }

  Widget buildGreetings(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome " + context.read<AuthContext>().user.name.split(" ")[0],
            style: TextStyle(
                fontFamily: GoogleFonts.mulish().fontFamily, fontSize: 22),
          ),
          Text(
            "My Doctor",
            style: TextStyle(
                fontFamily: GoogleFonts.mulish().fontFamily,
                fontSize: 32,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: 55,
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Color(0xffE8E8E8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.search,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 10),
                      child: Text(
                        'Search for items here',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Constants.PRIMARY_COLOR,
              ),
              child: SvgPicture.asset(
                "assets/ic_filter.svg",
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.mulish().fontFamily,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: GoogleFonts.mulish().fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 120,
          margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              categoryTile("Surgeon", "assets/ic_surgeon.png",
                  selectedCategories == 'Surgeon'),
              categoryTile("Urologist", "assets/ic_kidney.png",
                  selectedCategories == 'Urologist'),
              categoryTile("Dentist", "assets/ic_dentist.png",
                  selectedCategories == 'Dentist'),
              categoryTile("Allergist", "assets/ic_allergy.png",
                  selectedCategories == 'Allergist'),
            ],
          ),
        )
      ],
    );
  }

  Widget categoryTile(String title, String img, bool isSelected) {
    return Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Constants.PRIMARY_COLOR : const Color(0xffE3E3E3),
          ),
        ),
        child: InkWell(
          // ignore: avoid_print
          onTap: (() => {setSelectedCat(title)}),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                img,
                height: 50,
                width: 50,
                color: isSelected ? Constants.PRIMARY_COLOR : Colors.black,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.5,
                      fontFamily: GoogleFonts.mulish().fontFamily,
                      color:
                          isSelected ? Constants.PRIMARY_COLOR : Colors.black),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildDoctorsList() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: [
        doctorListTile("assets/dr_1.png", "Dr. Smith", "Surgeon", "4.7",
            "10.00 AM - 03.00 AM", false),
        doctorListTile("assets/dr_2.png", "Dr. Steve Son", "Urologist", "4.5",
            "10.00 AM - 03.00 AM", false),
        doctorListTile("assets/dr_3.png", "Dr. Banner", "Dentists", "5.0",
            "10.00 AM - 03.00 AM", false),
        doctorListTile("assets/dr_4.png", "Dr. Clart Jon", "Surgeon", "4.1",
            "10.00 AM - 03.00 AM", false),
      ],
    );
  }

  Widget doctorListTile(String img, String name, String specialist,
      String rating, String time, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ItemDetailsPage()));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xffE3E3E3),
          ),
          color: isSelected ? Constants.PRIMARY_COLOR : const Color(0xffFFFFFF),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              margin: const EdgeInsets.only(left: 5),
              child: CircleAvatar(
                backgroundImage: AssetImage(img),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 16.5,
                        fontFamily: GoogleFonts.mulish().fontFamily,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: Text(
                      specialist,
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.mulish().fontFamily,
                          color: isSelected ? Colors.white : Colors.black),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/ic_rating.svg",
                          height: 16,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            rating,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: GoogleFonts.mulish().fontFamily,
                                color:
                                    isSelected ? Colors.white : Colors.black),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/ic_time.svg",
                                height: 16,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xff436E8E),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily:
                                          GoogleFonts.mulish().fontFamily,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
