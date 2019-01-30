<?php

//creating response array
$response = array();

if($_SERVER['REQUEST_METHOD']=='POST'){

    $klant = $_REQUEST['klant'];
    $toestel = $_REQUEST['toestel'];
    $onderhoud = $_REQUEST['onderhoud'];

    $klantupdate = $_REQUEST['klantupdate'];
    $toestelupdate = $_REQUEST['toestelupdate'];
    $onderhoudupdate = $_REQUEST['onderhoudupdate'];

    //including the db operation file
    require_once '../includes/DbOperation.php';
    $db = new DbOperation();

    if ($klant != NULL)
    {
      //getting values
      $naam1 = $_REQUEST['naam'];
      $debnr1 = $_REQUEST['debnr'];
      $tel1 = $_REQUEST['tel'];
      $mobiel1 = $_REQUEST['mobiel'];
      $mail1 = $_REQUEST['mail'];
      $straat1 = $_REQUEST['straat'];
      $nr1 = $_REQUEST['nr'];
      $postcode1 = $_REQUEST['postcode'];
      $woonplaats1 = $_REQUEST['woonplaats'];
      $notities1 = $_REQUEST['notities'];
      $klant_id1 = $_REQUEST['klant_id'];


      //including the db operation file
      // require_once '../includes/DbOperation.php';

      // $db = new DbOperation();

      //inserting values
      if($db->createklantgegevens($naam1, $debnr1, $tel1, $mobiel1, $mail1, $straat1, $nr1, $postcode1, $woonplaats1, $notities1, $klant_id1)){
          $response['error']=false;
          $response['message']='Klant added successfully';
      } else{
          $response['error']=true;
          $response['message']='Could not add Klant';
      }
    }
    if ($klantupdate != NULL)
    {
      //getting values
      $naam1 = $_REQUEST['naam'];
      $debnr1 = $_REQUEST['debnr'];
      $tel1 = $_REQUEST['tel'];
      $mobiel1 = $_REQUEST['mobiel'];
      $mail1 = $_REQUEST['mail'];
      $straat1 = $_REQUEST['straat'];
      $nr1 = $_REQUEST['nr'];
      $postcode1 = $_REQUEST['postcode'];
      $woonplaats1 = $_REQUEST['woonplaats'];
      $notities1 = $_REQUEST['notities'];
      $klant_id1 = $_REQUEST['klant_id'];
      $klant_id2 = $_REQUEST['klant_id'];

      //including the db operation file
      // require_once '../includes/DbOperation.php';

      // $db = new DbOperation();

      //inserting values
      if($db->updateklantgegevens($naam1, $debnr1, $tel1, $mobiel1, $mail1, $straat1, $nr1, $postcode1, $woonplaats1, $notities1, $klant_id1, $klant_id2)){
          $response['error']=false;
          $response['message']='Klant Updated successfully';
      } else{
          $response['error']=true;
          $response['message']='Could not update Klant';
      }
      // $response['test']='Test';
    }

    if ($toestel != NULL)
    {
      $klant_id_toestel = $_REQUEST['klant_id_toestel'];
      $toestel_id_toestel = $_REQUEST['toestel_id_toestel'];
      $merk_toestel = $_REQUEST['merk_toestel'];
      $type_toestel = $_REQUEST['type_toestel'];
      $bouwjaar_toestel = $_REQUEST['bouwjaar_toestel'];
      $freq_toestel = $_REQUEST['freq_toestel'];
      $garantie_toestel = $_REQUEST['garantie_toestel'];
      $datum_toestel = $_REQUEST['datum_toestel'];
      $serienr_toestel = $_REQUEST['serienr_toestel'];
      $OGP_toestel = $_REQUEST['OGP_toestel'];

      //including the db operation file
      // require_once '../includes/DbOperation.php';

      // $db = new DbOperation();

      //inserting values
      if ($db->createnewtoestel($klant_id_toestel, $toestel_id_toestel, $merk_toestel, $type_toestel, $bouwjaar_toestel, $freq_toestel, $garantie_toestel, $datum_toestel, $serienr_toestel, $OGP_toestel)){
          $response['error']=false;
          $response['message']='Toestel added successfully';
      } else{
          $response['error']=true;
          $response['message']='Could not add Toestel';
      }
    }

    if ($toestelupdate != NULL)
    {
      $klant_id_toestel = $_REQUEST['klant_id_toestel'];
      $toestel_id_toestel = $_REQUEST['toestel_id_toestel'];
      $merk_toestel = $_REQUEST['merk_toestel'];
      $type_toestel = $_REQUEST['type_toestel'];
      $bouwjaar_toestel = $_REQUEST['bouwjaar_toestel'];
      $freq_toestel = $_REQUEST['freq_toestel'];
      $garantie_toestel = $_REQUEST['garantie_toestel'];
      $datum_toestel = $_REQUEST['datum_toestel'];
      $serienr_toestel = $_REQUEST['serienr_toestel'];
      $OGP_toestel = $_REQUEST['OGP_toestel'];
      $toestel_id2_toestel = $_REQUEST['toestel_id_toestel'];


      //inserting values
      if ($db->updatetoestel($klant_id_toestel, $toestel_id_toestel, $merk_toestel, $type_toestel, $bouwjaar_toestel, $freq_toestel, $garantie_toestel, $datum_toestel, $serienr_toestel, $OGP_toestel, $toestel_id2_toestel)){
          $response['error']=false;
          $response['message']='Toestel Updated successfully';
      } else{
          $response['error']=true;
          $response['message']='Could not update Toestel';
      }
    }

    if ($onderhoud != NULL)
    {
      $klant_id_onderhoud = $_REQUEST['klant_id_onderhoud'];
      $toestel_id_onderhoud = $_REQUEST['toestel_id_onderhoud'];
      $onderhoudsdatum_onderhoud = $_REQUEST['onderhoudsdatum_onderhoud'];
      $monteur_onderhoud = $_REQUEST['monteur_onderhoud'];
      $werkzaamheden_onderhoud = $_REQUEST['werkzaamheden_onderhoud'];
      $opmerkingen_onderhoud = $_REQUEST['opmerkingen_onderhoud'];
      $onderhoud_id_onderhoud = $_REQUEST['onderhoud_id_onderhoud'];

      //inserting values
      if ($db->createnewonderhoud($klant_id_onderhoud, $toestel_id_onderhoud, $onderhoudsdatum_onderhoud, $monteur_onderhoud, $werkzaamheden_onderhoud, $opmerkingen_onderhoud, $onderhoud_id_onderhoud)){
          $response['error']=false;
          $response['message']='Onderhoud added successfully';
      } else{
          $response['error']=true;
          $response['message']='Could not add Onderhoud';
      }
    }

    if ($onderhoudupdate != NULL)
    {
      $klant_id_onderhoud = $_REQUEST['klant_id_onderhoud'];
      $toestel_id_onderhoud = $_REQUEST['toestel_id_onderhoud'];
      $onderhoudsdatum_onderhoud = $_REQUEST['onderhoudsdatum_onderhoud'];
      $monteur_onderhoud = $_REQUEST['monteur_onderhoud'];
      $werkzaamheden_onderhoud = $_REQUEST['werkzaamheden_onderhoud'];
      $opmerkingen_onderhoud = $_REQUEST['opmerkingen_onderhoud'];
      $onderhoud_id_onderhoud = $_REQUEST['onderhoud_id_onderhoud'];
      $toestel_id2_onderhoud = $_REQUEST['toestel_id_onderhoud'];
      $werkzaamheden2_onderhoud = $_REQUEST['werkzaamheden_onderhoud'];
      

      //inserting values
      if ($db->updateonderhoud($klant_id_onderhoud, $toestel_id_onderhoud, $onderhoudsdatum_onderhoud, $monteur_onderhoud, $werkzaamheden_onderhoud, $opmerkingen_onderhoud, $onderhoud_id_onderhoud, $toestel_id2_onderhoud, $werkzaamheden2_onderhoud)){
          $response['error']=false;
          $response['message']='Onderhoud updated successfully';
      } else{
          $response['error']=true;
          $response['message']='Could not update Onderhoud';
      }
    }



} else{
    $response['error']=true;
    $response['message']='You are not authorized';
}
echo json_encode($response);
