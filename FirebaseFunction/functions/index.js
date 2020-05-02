const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;
var firestore = admin.firestore();

exports.notificationTriggerUpdated = functions.firestore.document('messages/{messageId}').onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No messages');
        return;
    }

    newData = snapshot.data();
 
    var tokens = []; 
    var usersDocuments
    var allUsersdeviceTokensDocuments = [];

    if (newData.messageType === 'announcement') {
        // Announcement message
        usersDocuments = await firestore.collection('users').get();
    } else {
        // Private message
        usersDocuments = await firestore.collection('users').where('email', '==', newData.receiverEmail).get();

    }

    usersDocuments.forEach(async function (userDocument) {
        if (userDocument.data().email === newData.senderEmail) {
            // Skip the user who posted the message
            
        } else {
            const deviceTokensDocuments = await firestore.collection('users').doc(userDocument.data().documentID).collection('deviceTokens').get();
            allUsersdeviceTokensDocuments.push(deviceTokensDocuments);
        }      
    });


    for (var deviceTokenDocument in allUsersdeviceTokensDocuments) {
        deviceTokenDocument.forEach((token) => tokens.push(token.data().deviceToken));
    }

    var payload = {
        notification : {title: 'Announcement', body: newData.messageTitle, sound: 'default'},
        data: {click_action: 'FLUTTER_NOTIFICATION_CLICK' , message: newData.message}
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
