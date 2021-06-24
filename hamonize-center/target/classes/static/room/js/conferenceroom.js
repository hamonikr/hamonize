/*
 * (C) Copyright 2014 Kurento (http://kurento.org/)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

var ws = new WebSocket('wss://' + location.host + '/groupcall');
var participants = {};
var name;

window.onbeforeunload = function() {
	ws.close();
};

ws.onmessage = function(message) {
	var parsedMessage = JSON.parse(message.data);
	console.info('Received message: ' + message.data);
	var d = new Date();
	var n = d.getTime();
	console.info('Received message time check : ' + new Date().toString() +"> milliseconds is "+ n);
	
	switch (parsedMessage.id) {
	case 'existingParticipants':
		console.info("existingParticipants====");
		//onExistingParticipants(parsedMessage);
		break;
	case 'newParticipantArrived':
		console.info("newParticipantArrived====");
		//onNewParticipant(parsedMessage);
		break;
	case 'participantLeft':
		console.info("participantLeft====");
		//onParticipantLeft(parsedMessage);
		break;
	case 'receiveVideoAnswer':
		console.info("receiveVideoAnswer====");
		//receiveVideoResponse(parsedMessage);
		break;
	case 'iceCandidate':
		console.info("iceCandidate====");
		participants[parsedMessage.name].rtcPeer.addIceCandidate(parsedMessage.candidate, function (error) {
			 if (error) {
				console.info("Error adding candidate: " + error);
				return;
			} else {
//				console.info('iceCandidate message: ' + message.data + ", milliseconds is "+ n);
//				 console.info('Received message333: ' + new Date().toString());
			}
	    });
	    break;

	case 'joinRoomtest':
		
		console.log("parsedMessage.name==="+ parsedMessage.txtData);
		console.log("parsedMessage.name==="+ parsedMessage.baseData);
		console.log("parsedMessage.name==="+ parsedMessage.sendLanguage);
		console.log("parsedMessage.name==="+ parsedMessage.receiveLanguage);
		pubFaceHide(parsedMessage.txtData, message.data, parsedMessage.baseData, parsedMessage.sendLanguage, parsedMessage.receiveLanguage);
		break;
		 
	default:
		console.error('Unrecognized message', parsedMessage);
	}
}



function register() {
	name = document.getElementById('name').value;
	var room = document.getElementById('roomName').value;
	
	document.getElementById('join').style.display = 'none';
	document.getElementById('room').style.display = 'block';

	var message = {
		id : 'joinRoom',
		name : name,
		room : room,
	}
	sendMessage(message);
}

function onNewParticipant(request) {
	receiveVideo(request.name);
}

function receiveVideoResponse(result) {
	participants[result.name].rtcPeer.processAnswer (result.sdpAnswer, function (error) {
		if (error) return console.error (error);
	});
}

function callResponse(message) {
	if (message.response != 'accepted') {
		console.info('Call not accepted by peer. Closing call');
		stop();
	} else {
		webRtcPeer.processAnswer(message.sdpAnswer, function (error) {
			if (error) return console.error (error);
		});
	}
}

function onExistingParticipants(msg) {
	var constraints = {
		audio : true,
		video : {
			mandatory : {
				maxWidth : 1280,
				maxFrameRate : 15,
				minFrameRate : 15
			}
		}
	};
	console.log(name + " registered in room " + room);
	var participant = new Participant(name);
	participants[name] = participant;
	var video = participant.getVideoElement();

	var options = {
	      localVideo: video,
	      mediaConstraints: constraints,
	      onicecandidate: participant.onIceCandidate.bind(participant)
	    }
	participant.rtcPeer = new kurentoUtils.WebRtcPeer.WebRtcPeerSendonly(options,
		function (error) {
		  if(error) {
			  return console.error(error);
		  }
		  this.generateOffer (participant.offerToReceiveVideo.bind(participant));
	});

	msg.data.forEach(receiveVideo);
}

function leaveRoom() {
	sendMessage({
		id : 'leaveRoom'
	});

	for ( var key in participants) {
		participants[key].dispose();
	}

	document.getElementById('join').style.display = 'block';
	document.getElementById('room').style.display = 'none';

	ws.close();
	window.open("about:blank","_self").close();
}

function receiveVideo(sender) {
	var participant = new Participant(sender);
	participants[sender] = participant;
	var video = participant.getVideoElement();

	var options = {
      remoteVideo: video,
      onicecandidate: participant.onIceCandidate.bind(participant)
    }

	participant.rtcPeer = new kurentoUtils.WebRtcPeer.WebRtcPeerRecvonly(options,
			function (error) {
			  if(error) {
				  return console.error(error);
			  }
			  this.generateOffer (participant.offerToReceiveVideo.bind(participant));
	});;
}

function onParticipantLeft(request) {
	var participant = participants[request.name];
	participant.dispose();
	delete participants[request.name];
}

function sendMessage(message) {
	var jsonMessage = JSON.stringify(message);
	console.log('Senging message: ' + jsonMessage);
	ws.send(jsonMessage);
}

var hotelWorker, languageChk;
function textSend(){
	//hotelWorker = document.getElementById("hotelWorker").value;
	var dataChannelSend = document.getElementById('dataChannelSend');
	languageChk = $("#languageChk option:selected").val();
	
	var sendButton = document.getElementById('send');
	var data = dataChannelSend.value;
	console.log("Send button pressed. Sending data " + data);
    
	 var message2 = {
 			id : 'joinRoomtest',
 			name : name,
			txtData : data,
			languageChk : languageChk,
 			room : document.getElementById('roomName').value,
 		}
	sendMessage(message2);    
	 
}


function pubFaceHide( txtData , msgJson, baseData, sendLanguage, receiveLanguage){
	var tmpMessage = JSON.parse(msgJson);

	
	if( tmpMessage.name == document.getElementById("name").value ){
		document.getElementById("textMessageChannel").innerHTML += "<p class=\"red\">["+document.getElementById("name").value + "]<br></p>" ;	
		document.getElementById("textMessageChannel").innerHTML += "<p class=\"red\">&nbsp;&nbsp;"+baseData +"(ko)<br></p>" ;	

	
	}else{
		document.getElementById("textMessageChannel").innerHTML += "<p class=\"blue\">["+tmpMessage.name + "]<br></p>" ;
		document.getElementById("textMessageChannel").innerHTML += "<p class=\"blue\">&nbsp;&nbsp;"+ txtData +"(ko)<br></p>" ;
	}
	
	document.getElementById("dataChannelSend").value = " ";
}