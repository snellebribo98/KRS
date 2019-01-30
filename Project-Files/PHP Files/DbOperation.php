<?php

class DbOperation
{
    private $conn;

    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DbConnect.php';
        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();
    }

    //Function to create a new user
    public function createklantgegevens($naam1, $debnr1, $tel1, $mobiel1, $mail1, $straat1, $nr1, $postcode1, $woonplaats1, $notities1, $klant_id1)
    {
        $stmt = $this->conn->prepare("INSERT INTO Klantengegevens(naam, debnr, tel, mobiel, mail, straat, nr, postcode, woonplaats, notities, klant_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssssssssi", $naam1, $debnr1, $tel1, $mobiel1, $mail1, $straat1, $nr1, $postcode1, $woonplaats1, $notities1, $klant_id1);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

    public function updateklantgegevens($naam1, $debnr1, $tel1, $mobiel1, $mail1, $straat1, $nr1, $postcode1, $woonplaats1, $notities1, $klant_id1, $klant_id2)
    {
      $stmt = $this->conn->prepare("UPDATE Klantengegevens SET naam = ?, debnr = ?, tel = ?, mobiel = ?, mail = ?, straat = ?, nr = ?, postcode = ?, woonplaats = ?, notities = ?, klant_id = ? WHERE klant_id = ?");
      $stmt->bind_param("ssssssssssii", $naam1, $debnr1, $tel1, $mobiel1, $mail1, $straat1, $nr1, $postcode1, $woonplaats1, $notities1, $klant_id1, $klant_id2);
      $result = $stmt->execute();
      $stmt->close();
      if ($result) {
          return true;
      } else {
          return false;
      }
    }

    public function createnewtoestel($klant_id, $toestel_id, $merk, $type, $bouwjaar, $freq, $garantie, $datum, $serienr, $OGP)
    {
        $stmt = $this->conn->prepare("INSERT INTO Toestellen(klant_id, toestel_id, merk, type, bouwjaar, freq, garantie, datum, serienr, OGP) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("iissssssss", $klant_id, $toestel_id, $merk, $type, $bouwjaar, $freq, $garantie, $datum, $serienr, $OGP);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

    public function updatetoestel($klant_id, $toestel_id, $merk, $type, $bouwjaar, $freq, $garantie, $datum, $serienr, $OGP, $toestel_id2)
    {
        $stmt = $this->conn->prepare("UPDATE Toestellen SET klant_id = ?, toestel_id = ?, merk = ?, type = ?, bouwjaar = ?, freq = ?, garantie = ?, datum = ?, serienr = ?, OGP = ? WHERE toestel_id = ?");
        $stmt->bind_param("iissssssssi", $klant_id, $toestel_id, $merk, $type, $bouwjaar, $freq, $garantie, $datum, $serienr, $OGP, $toestel_id2);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

    public function createnewonderhoud($klant_id, $toestel_id, $onderhoudsdatum, $monteur, $werkzaamheden, $opmerkingen, $onderhoud_id)
    {
        $stmt = $this->conn->prepare("INSERT INTO Onderhouden(klant_id, toestel_id, onderhoudsdatum, monteur, werkzaamheden, opmerkingen, onderhoud_id) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("iissssi", $klant_id, $toestel_id, $onderhoudsdatum, $monteur, $werkzaamheden, $opmerkingen, $onderhoud_id);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

    public function updateonderhoud($klant_id, $toestel_id, $onderhoudsdatum, $monteur, $werkzaamheden, $opmerkingen, $onderhoud_id, $toestel_id2, $werkzaamheden2)
    {
        $stmt = $this->conn->prepare("UPDATE Onderhouden SET klant_id = ?, toestel_id = ?, onderhoudsdatum = ?, monteur = ?, werkzaamheden = ?, opmerkingen = ?, onderhoud_id = ? WHERE toestel_id = ? AND onderhoud_id = ?");
        $stmt->bind_param("iissssiii", $klant_id, $toestel_id, $onderhoudsdatum, $monteur, $werkzaamheden, $opmerkingen, $onderhoud_id, $toestel_id2, $onderhoud_id);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

}
