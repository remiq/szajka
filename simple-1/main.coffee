txtLocalOffer = document.querySelector 'textarea#txtLocalOffer'
txtRemoteOffer = document.querySelector 'textarea#txtRemoteOffer'

dataConstraint = null
servers = null
options =
  optional: [
    _ =
      RtpDataChannels: true
  ]

events =
  onError: () ->
    console.log "random error catched"
  onLocalOffer: (offer) ->
    txtLocalOffer.innerHTML = offer.sdp


localConnection = new RTCPeerConnection servers, options
localChannel = localConnection.createDataChannel 'sendDataChannel', dataConstraint
localConnection.createOffer events.onLocalOffer, events.onError

# TODO: txtRemoteOffer onChange should create Connection and Channel
# TODO: add "copy & paste" button under txtRemoteOffer to test in one browser
