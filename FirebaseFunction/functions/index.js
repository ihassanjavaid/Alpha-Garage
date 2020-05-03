const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var notificationData;

exports.notificationTriggerUpdated = functions.firestore.document('messages/{messageId}').onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No messages');
        return;
    }

    notificationData = snapshot.data();
 
    var tokens = []; 

    const deviceTokens = await admin.firestore().collection('deviceTokens').get();

    if (notificationData.messageType === 'privateMessage') {
        for (var privateToken of deviceTokens.docs) {
            if (privateToken.data().email === notificationData.receiverEmail) {
                tokens.push(privateToken.data().deviceToken);
            }
        }
    } else {
        for (var token of deviceTokens.docs) {
            tokens.push(token.data().deviceToken);
        } 
    }

    var payload = {
        notification : {title: notificationData.messageTitle, body: notificationData.messageText, sound: 'default'},
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK' , message: notificationData.messageText}
    };

    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log('Notification sent sucessfully.');
    } catch (err) {
        console.log('Error sending notification.'+ err);
    }

});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
