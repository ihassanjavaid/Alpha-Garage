const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.notificationTrigger = functions.firestore.document('messages/{messageId}').onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No messages');
        return;
    }

    newData = snapshot.data;

    var tokens = [
        'cBWf6VujWFQ:APA91bGys4eRXhW3iZQB0b97oaj-gZzC-kHalgPNGEPtqXKUCnISzJBjP7CIodChipiQmgWPup_z6gy7k_Z0tEJxZTZ-y3SEgpIe6TtOoF8TZBiKncCF6eJ0peWzZ-AsaUa7qWvnCSio'
    ];

    var payload = {
        notification : {title: 'Push Title', body: 'Push body', sound: 'default'},
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK' , message: 'Push notification message'}
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
