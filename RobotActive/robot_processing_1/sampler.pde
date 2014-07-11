
import apwidgets.*;

String files[] = {
  "Countdown-Me-728881159.mp3","Dying Robot-SoundBible.com-1721415199.mp3","Old Sub Sonar-SoundBible.com-2099530271.mp3","ROBOT.WAV","Robot Machine-SoundBible.com-169984638.mp3","Robot_blip-Marianne_Gagnon-120342607.mp3","Robot_blip_2-Marianne_Gagnon-299056732.mp3","Sci Fi Robot-SoundBible.com-481033379.mp3","Short Circuit-SoundBible.com-1450168875.mp3","robot_walk.mp3"};

APMediaPlayer[] player;
void sampler_begin()
{
  
  player =  new APMediaPlayer[files.length];
  for (int i = 0; i < files.length;i++)
  {
    player[i] = new APMediaPlayer(this); //create new APMediaPlayer
    player[i].setMediaFile(files[i]); //set the file (files are in data folder)
  //  player[i].start(); //start play back
    player[i].setLooping(false); //restart playback end reached
    player[i].setVolume(1.0, 1.0); //Set left and right volumes. Range is from 0.0 to 1.0
  } 
  
}

void sampler_play(int num)
{
  if(num < files.length)
  {
    player[num].start();
  }
  
}


