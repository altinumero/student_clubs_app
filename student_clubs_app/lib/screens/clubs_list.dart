
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_clubs_app/screens/club_detail.dart';
import 'package:student_clubs_app/utils/colors.dart';


class ClubsList extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Appcolors.mainColor,
        centerTitle: true,
        title: Text("Clubs List"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed:
                () {}, //Burada eğer kullanıcı giriş yapmışsa profil sayfasına yoksa logine gidecek
          ),
        ],
      ),
      body: StreamBuilder(
        stream:Firestore.instance
            .collection('clubs')
            .snapshots(),
        builder:(context,streamSnapshot) {
          if(streamSnapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamSnapshot.data.documents;
          return ListView.builder(
            itemCount: streamSnapshot.data.documents.length,
            itemBuilder: (context,index)=> Card(

              color:Colors.deepPurpleAccent,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                    child:Text("Club"),
                    backgroundImage: NetworkImage(documents[index]['clubImage']),
                    backgroundColor: Colors.transparent
                ),
                title: Text(documents[index]['ClubName']+ " Club"),
                //subtitle: Text(documents[index]['Description']),

                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ClubDetail(
                        clubnamedata:documents[index]['ClubName'],clubpresidentdata:documents[index]['ClubPresident'],clubdescriptiondata:documents[index]['Description'],clubimagedata:documents[index]['clubImage'])
                    ),
                  );
                },
              ),
            ),);
        },
      ),


    );
  }


}
