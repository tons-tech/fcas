alert("hoge");

const media = { audio: true, video: { facingMode: "user" } },
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
    console.log('error');
}

//videoの縦幅横幅を取得
var w = video.offsetWidth;
var h = video.offsetHeight;
canvas.setAttribute("width", w);
canvas.setAttribute("height", h);

$('#snap').on('click',function(){
    context.drawImage(video, 0, 0, w, h);
    snapped.src = canvas.toDataURL('image/png');
})
;
