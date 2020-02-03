
import processing.video.*;
import jp.nyatla.nyar4psg.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

float angleX = 0;
float angleY = 0;
float angleZ = 0;

ArrayList<PVector> vectors = new ArrayList<PVector>();
float beta = 0;

float MaxSound = 0;
float[] Maxs;
float lifespan = 100;


Minim minim;
// オーディオ入力の変数を用意します
AudioInput in;
// FFTの変数を用意します
FFT fft;



/**
 * NyARToolkit for proce55ing/3.0.5
 * (c)2008-2017 nyatla
 * airmail(at)ebony.plala.or.jp
 * 
 * 最も短いARToolKitのコードです。
 * Hiroマーカの上に立方体を表示します。
 * 全ての設定ファイルとマーカファイルはスケッチディレクトリのlibraries/nyar4psg/dataにあります。
 * 
 * This sketch is shortest sample.
 * The sketch shows cube on the marker of "patt.hiro".
 * Any pattern and configuration files are found in libraries/nyar4psg/data inside your sketchbook folder. 
*/


Capture cam;
MultiMarker nya;

void setup() {  
  // Minim を初期化します
  minim = new Minim(this);
  // ステレオオーディオ入力を取得します
  in = minim.getLineIn(Minim.STEREO, 512);
  // ステレオオーディオ入力を FFT と関連づけます
  fft = new FFT(in.bufferSize(), in.sampleRate());

  size(1440,900,P3D);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  cam=new Capture(this,1440,900);
  nya=new MultiMarker(this,width,height,"camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
  nya.addARMarker("pattern-mennheratyan.patt",80);
  //"../../data/patt.hiro"
  cam.start();
  frameRate(20);
}

void draw()
{
   // FFT 実行
  //左右の入力音を mix して FFT
  fft.forward(in.mix);
  // FFTのスペクトラムの幅を変数に保管します
  //specSize=257
  //int specSize = fft.specSize();
    
  MaxSound = max(fft.getBand(26),fft.getBand(50));
    
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam);//frustumを考慮した背景描画
  if((!nya.isExist(0))){
    return;
  }
  //background(0);
  translate(width/2,height/2);
  rotateX(angleX);
  rotateY(angleY);
  rotateZ(angleZ);
  
  angleX += 0.01;
  angleY += 0.02;
  angleZ += 0.01;

//スマホサイズ
 //float Ran = random(-100,100);
 //Ran += Ran/100;

 // float r = (200+Ran)*(0.8 +1.6 *sin(6 * beta));
 // float theta = 2 * beta;
 // float phi = 0.6 * PI * sin(12 * beta);
 // float x = r * cos(phi) * cos(theta) + MaxSound*random(-500,500);
 // float y = r * cos(phi) * sin(theta) + MaxSound*random(-500,500);
 // float z = r * sin(phi) + MaxSound*random(-500,500);
 // //stroke(255,r,255);
 // beta += 0.01;
  
 
 float Ran = random(-50,50);
 Ran += Ran/100;

  float r = (200+Ran)*(0.8 +1.6 *sin(6 * beta));
  float theta = 2 * beta;
  float phi = 0.6 * PI * sin(12 * beta);
  float x = r * cos(phi) * cos(theta) + MaxSound*random(-800,800);
  float y = r * cos(phi) * sin(theta) + MaxSound*random(-800,800);
  float z = r * sin(phi) + MaxSound*random(-800,800);
  //stroke(255,r,255);
  beta += 0.01;
  
  vectors.add(new PVector(x,y,z));
  
  noFill();
  //stroke(255);
  float e = 10;
  if(MaxSound>1){e= random(10,20);};
  strokeWeight(e);
  beginShape();
   colorMode(HSB,360,100,100,100);
   
   for(PVector v : vectors){
    float d = v.mag()*MaxSound*10;
    //lifespan -= 4;
    if(d>360){
      d = d-360;   
      if(d>360){
        d = d-360;
        if(d>360){
        d = d-360;
          if(d>360){
          d = d-360;  
          }
        }
      }
    };
    stroke(d,80,80,100);
    vertex(v.x, v.y, v.z);
   }
  
endShape();
}
