import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:soom/main.dart';


class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String? msg;

  String? snapShot;

  String? value;

  String? error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Scaffold build(BuildContext context) {
//     // Configer the logging
//     Logger.root.level = Level.ALL;
// // Writes the log messages to the console
//     Logger.root.onRecord.listen((LogRecord rec) {
//       print('${rec.level.name}: ${rec.time}: ${rec.message}');
//     });
//
// // If you want only to log out the message for the higer level hub protocol:
//     final hubProtLogger = Logger("SignalR - hub");
// // If youn want to also to log out transport messages:
//     final transportProtLogger = Logger("SignalR - transport");
//
//     serverUrl = "https://sell-order.com/bidhub";
//     final httpOptions = HttpConnectionOptions(
//       logger: transportProtLogger,
//       httpClient: WebSupportingHttpClient(
//         transportProtLogger,
//         httpClientCreateCallback: (httpClient) => serverUrl,
//
//       ),
//       accessTokenFactory: () => Future.value(token),
//     );
//
//     final hubConnection = HubConnectionBuilder()
//         .withUrl(serverUrl, options: httpOptions)
//         .configureLogging(hubProtLogger)
//         .build();
//     hubConnection.onclose(({error}) {
//       setState(() {
//         msg = "connection closed " ;
//       });
//       print("Connection Closed");
//     });
//
//     hubConnection.on("listen", (arguments) {
//       setState(() {
//         print("++++++++++ create lisetner  success   +++++++++++++++++++++++++++++++++++++++++++++++++++");
//       setState(() {
//         msg = "${arguments?[0].toString()} on ------------- ";
//       });
//       });
//
//     });
//     if(hubConnection.state != HubConnectionState.Connected){
//       hubConnection.start()?.then((value) {
//         msg = "connected start  \n id = ${hubConnection.connectionId}" ;
//       }).catchError((eee) {
//         print("erorr: $eee");
//       });
//     }
//     _connectStart() async {
//        await hubConnection.invoke("listen").then((value) {
//         print("++++++++++ success invoke +++++++++");
//         msg = value.toString() ;
//         setState(() {
//
//         });
//       }).catchError((err) {
//         print("++++++++++ catch error invoke +++++++++");
//         msg = err.toString();
//         print(err.toString());
//       });
//     }
//
//    if(hubConnection.state ==  HubConnectionState.Connected){
//      _connectStart();
//    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await _connectStart();
        },
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              msg ?? "uuu",
              style: const TextStyle(
                fontSize: 50,
              ),
            ),

          ),
          // ElevatedButton(onPressed: ()async{
          //   hubConnection.off("listen" );
          // }, child: const  Text("connection close")) ,
          // ElevatedButton(onPressed: ()async{
          //   await hubConnection.invoke("listen");
          //   hubConnection.on("listen", (arguments) {
          //     print("++++++++++++++++++++++++++++++");
          //     print(arguments.toString());
          //   });
          //
          // }, child: const  Text("on")) ,
          ElevatedButton(onPressed: ()async{
            final connection = HubConnectionBuilder().withUrl('https://sell-order.com/bidhub',
                HttpConnectionOptions(
                  logging: (level, message) => print(message),
                  accessTokenFactory: () => Future.value(token) ,
                  withCredentials: false ,
                )).build();

            await connection.start();
            print(
              "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" +
                connection.connectionId.toString()
            );

            connection.on('GetlastBid', (message) {
              print(message.toString());
              print(
                  "_________________  on _________________________________________________" +
                      connection.connectionId.toString()
              );
            });

            await connection.invoke('GetlastBid' , args: [2]).then((value){
              print(
                  "_________________  invoke success  _________________________________________________" +
                      connection.connectionId.toString() +
                  value.toString()
              );
            });
          }, child: const  Text("1111111 ") , ) ,

          Image.network("https://sell-order.com/File/DownloadBinaryFile?id=8bfc80c2-6bc8-8746-ce09-3a06032d2ee2"),
        ],
      ),
    );
  }

  // The location of the SignalR Server.
  var serverUrl = "https://sell-order.com/bidhub";

  void _handleIncommingChatMessage(List<Object> args) {
    setState(() {
      msg = args[0].toString();
    });
  }
}
