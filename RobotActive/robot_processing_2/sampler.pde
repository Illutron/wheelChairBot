
import apwidgets.*;

String files[] = {
  
"01_01.wav","01_02.wav","01_03.wav","01_04.wav","01_05.wav","02_01.wav","02_02.wav","02_03.wav","02_04.wav","03_01_hvem_er_din_ven.wav","03_02_din_ven_ser_trat_ud.wav","03_03_din_ven_ser_vred_ud.wav","04_01_hvad_stirrer_du_pa.wav","04_02_har_vi_set_hinanden_for.wav","04_03_jeg_har_set_dig_for.wav","04_04_hvordan_kom_du_ind.wav","05_01_stille.wav","05_02_ti_stille.wav","05_03_shhhhh.wav","05_04_shhhh.wav","05_05_hor.wav","05_06_hor.wav","06_01_jeg_kommer_lige_lidt_narmere.wav","06_02_jeg_korer_lige_lidt_langere_vak.wav","07_01_stille.wav","07_02_ti_stille.wav","07_03_shhhh.wav","07_04_hor.wav","08_01_din_bla_kjole_er_flot.wav","08_02_din_sorte_hat_er_pan.wav","08_03_din_rade_bluse_er_pan.wav","08_04_din_gronne_jakke_er_flot.wav","09_01_nyn.wav","09_02_nyn.wav","09_03_nyn.wav","09_04_nyn.wav","09_05_nyn.wav","09_06_nyn.wav","10_01_nyn.wav","10_02_nyn.wav","10_03_nyn.wav","10_04_nyn.wav","10_07_nyn.wav","11_01_ahr.wav","11_02_ahr.wav","11_03_ahr.wav","11_04_ahr.wav","11_05_ahr.wav","11_06_ahr.wav","11_07_ahr.wav","11_08_mmyahr.wav","11_09_mmmahrr.wav","12_01_ahrrrrrrrr_dark.wav","12_02_ahrrrr_dark.wav","12_03_arrrrrr.wav","13_01_clash_dry.wav","13_02_uahr.wav","13_03_hah_breath_out.wav","13_04_hahe.wav","13_05_ehahh.wav","14_01_rrrrrrr.wav","14_02_aiairrrrr.wav","14_03_hairrrr.wav","14_04_ahhhhhrrrr.wav","14_05_ohrahhrr.wav","14_06_ahrrr.wav"

//"15_01_nynne_section.wav","15_02_nynne_section.wav","16_01_hej.wav","16_02_hej.wav","16_03_hej.wav","16_04_hej.wav","16_05_hej.wav","16_06_hej.wav","16_07_hej.wav","16_08_hej.wav","16_09_hej.wav","17_01_hej_med_dig.wav","17_02_hej_med_dig.wav","17_03_hej_med_dig.wav","17_04_hej_med_dig.wav","17_05_hej_med_dig.wav","17_06_hej_med_dig.wav","17_07_hej_med_dig.wav","17_08_hej_med_dig.wav","18_01_hej_med_jer.wav","18_02_hej_med_jer.wav","18_03_hej_med_jer.wav","18_04_hej_med_jer.wav","18_05_hej_med_jer.wav","18_06_hej_med_jer.wav","19_01_hej_hej.wav","19_02_hej_hej.wav","19_03_hej_hej.wav","19_04_hej_hej.wav","19_05_hej_hej.wav","19_06_hej_hej.wav","19_07_hej_hej.wav","19_08_hej_hej.wav","19_09_hej_hej.wav","19_10_hej_hej.wav","20_01_farvel.wav","20_02_farvel.wav","20_03_farvel.wav","20_04_farvel.wav","20_05_farvel.wav","20_06_farvel.wav","20_07_farvel.wav","21_01_jeg_kommer_lige_hen_til_dig.wav","21_02_hej_jeg_kommer_hen_til_dig.wav","21_03_hej_jeg_kommer_lige_hen_til_dig.wav","21_04_hej_jeg_kommer_lige_narmere.wav","21_05_hej_jeg_kommer_nu.wav","22_01_nu_bliver_jeg_helt_forvirret.wav","22_02_nu_bliver_jeg_helt_forvirret.wav","22_03_ah_nej_nu_bliver_jeg_helt_forvirret.wav","22_04_ah_nej_jeg_bliver_helt_forvirret.wav","23_01_hvor_er_det_dejligt_i_er_her_allesammen.wav","23_02_hvor_er_det_dejligt_i_er_her_allesammen.wav","23_03_hvor_er_det_dejligt_at_i_er_her_allesammen.wav","24_01_sikke_mange_venner_jeg_har.wav","24_02_sikke_mange_venner_jeg_har.wav","24_03_sikke_mange_venner_jeg_har.wav","24_04_sikke_mange_venner_jeg_har.wav","25_01_du_er_min_bedste_ven.wav","25_02_du_er_min_bedste_ven.wav","25_03_du_er_min_bedste_ven.wav","25_04_du_er_min_bedste_ven.wav","25_05_du_er_min_bedste_ven.wav","26_01_vil_i_allesammen_se_min_udstilling.wav","26_02_vil_i_allesammen_se_min_udstilling.wav","26_03_vil_i_allesammen_se_mig_pa_min_udstilling.wav","27_01_se_mig.wav","27_02_lige_her_over.wav","27_03_se_mig.wav","27_04_lige_her_over.wav","27_05_se_mig.wav","27_06_se_mig_herovre.wav","27_07_dudu.wav","28_01_hvor_er_du_blevet_stor.wav","28_02_hvor_er_du_blevet_stor.wav","28_03_hvor_er_du_blevet_stor.wav","Robot_blip-Marianne_Gagnon-120342607.mp3","Robot_blip_2-Marianne_Gagnon-299056732.mp3","Sci Fi Robot-SoundBible.com-481033379.mp3"
};

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


