const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.notificationTrigger = functions.firestore.document('messages/{messageId}').onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No messages');
        return;
    }

    newData = snapshot.data();

    var tokens = []; 

    const users = await admin.firestore().collection('users').get();

    for (var user of users.docs) {
        const deviceTokens = await admin.firestore().collection('users').document(user.data().id).collection('deviceTokens').get();
        for (var token of deviceTokens.docs) {
            tokens.push(token.data().device_token);
        }
    }

    var payload = {
        notification : {title: 'Push Title', body: 'Push body', sound: 'default'},
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK' , message: newData.message}
    };

    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent sucessfully.');
    } catch (err) {
        console.log('Error sending notification.');
    }

});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
