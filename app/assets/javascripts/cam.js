$(function(){

const media = { audio: false, video: { facingMode: "user" } },
    video = document.getElementById('video'),
    canvas = document.getElementById('canvas'),
    context = canvas.getContext('2d'),
    snap = document.getElementById('snap'),
    snapped = document.getElementById('snapped');

navigator.getUserMedia(media, successCallBack, errorCallBack);

function successCallBack(stream){
    video.srcObject = stream;
}


function errorCallBack(){
    console.log('something going wrong with video');
}


$('#snap').on('click',function(){
//videoの縦幅横幅を取得
    var w = video.offsetWidth;
    var h = video.offsetHeight;
    canvas.setAttribute("width", w);
    canvas.setAttribute("height", h);
    console.log("width:" + w + "height:" + h);

    context.drawImage(video, 0, 0, w, h);
    snapped.src = canvas.toDataURL('image/jpeg', 0.5);

    //sendData(snapped.src);
    sendData(snapped.src);

})

function sendData(data) {
    $.ajax({
        url: "branch_duty",
        type: "POST",
        data: {
            image: data.replace(/^.*,/, '')
        },
        success: function(data) {
            console.log("YEAHHHHH");
        },
        error: function(data) {
            console.log("something happened");
        }
    });
};


});