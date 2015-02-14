txtLocalOffer = document.querySelector 'textarea#txtLocalOffer'
txtRemoteOffer = document.querySelector 'textarea#txtRemoteOffer'
txtLocalAnswer = document.querySelector 'textarea#txtLocalAnswer'
txtRemoteAnswer = document.querySelector 'textarea#txtRemoteAnswer'

btnCopyOffer = document.querySelector '#btnCopyOffer'
btnCopyAnswer = document.querySelector '#btnCopyAnswer'

dataConstraint = null
servers =
  iceServers: [
    _ =
      url: "stun:stun3.l.google.com:19302"
  ]
options =
  optional: [
    _ =
      RtpDataChannels: true
  ]

events =
  onError: () ->
    console.log "random error catched"
  onLocalIce: (ev) ->
    if ev.candidate
      console.log "onLocalIce"
      if window.remoteConnection
        console.log "added remoteCandidate"
        window.remoteConnection.addIceCandidate ev.candidate
  onRemoteIce: (ev) ->
    if ev.candidate
      console.log "onRemoteIce"
      if window.localConnection
        window.localConnection.addIceCandidate ev.candidate
  onLocalOffer: (desc) ->
    txtLocalOffer.innerHTML = JSON.stringify desc
    window.localConnection.setLocalDescription desc
  onRemoteOffer: () ->
    offer = txtRemoteOffer.value
    desc = new RTCSessionDescription JSON.parse offer
    window.remoteConnection = new RTCPeerConnection servers, options
    window.remoteConnection.onicecandidate = events.onRemoteIce
    window.remoteConnection.setRemoteDescription desc
    window.remoteConnection.createAnswer events.onRemoteAnswer, events.onError
  onRemoteAnswer: (desc) ->
    txtLocalAnswer.innerHTML = JSON.stringify desc
    window.remoteConnection.setLocalDescription desc
  onLocalAnswer: () ->
    offer = txtLocalAnswer.value
    desc = new RTCSessionDescription JSON.parse offer
    window.localConnection.setRemoteDescription desc
  onLocalChannelOpen: (ev) ->
    console.log "onLocalChannelOpen"
    console.log ev
  onLocalChannelClose: (ev) ->
    console.log "onLocalChannelClose"
    console.log ev



txtRemoteOffer.addEventListener "change", events.onRemoteOffer
#txtRemoteAnswer.addEventListener "change", events.onRemoteAnswer

btnCopyOffer.addEventListener "click", () ->
  txtRemoteOffer.value = txtLocalOffer.innerHTML
  events.onRemoteOffer()

btnCopyAnswer.addEventListener "click", () ->
  txtRemoteAnswer.value = txtLocalAnswer.innerHTML
  events.onLocalAnswer()



window.localConnection = null
window.remoteConnection = null
window.localConnection = new RTCPeerConnection servers, options
window.localConnection.onicecandidate = events.onLocalIce
localChannel = window.localConnection.createDataChannel 'sendDataChannel', dataConstraint
localChannel.onopen = events.onLocalChannelOpen
window.localConnection.createOffer events.onLocalOffer, events.onError

# TODO: txtRemoteOffer onChange should create Connection and Channel
# TODO: add "copy & paste" button under txtRemoteOffer to test in one browser
