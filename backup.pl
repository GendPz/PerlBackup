#!/usr/bin/perl
# Backup Perlscript
# Version 7 
# abgeschlossen
use strict;
use warnings;

### Hauptsubroutinen ###

# Configdatei wird geöffnet und eingelesen
sub Configdatei_laden
{
	my $fehler = "";
	if(-e "backupconfig")
	{
		open(DATEI, "backupconfig") or die $!;
			my @configinput = <DATEI>;
			chomp(@configinput);
		close(DATEI);
		return @configinput;
	}
	else
	{
		if(-e "logfile")
		{
			$fehler = "true";
			open (DATEI, ">>logfile") or die $!;
				printf DATEI "ACHTUNG backupconfig DATEI wurde nicht gefunden bitte DATEI erstellen und Pfade der Dateien die kopiert werden sollen eintragen\n";
				printf DATEI "Bitte Vorlage verwenden! Dateiname: backupconfig\n";
				printf DATEI "Pfad/Dateiname\n";
			close (DATEI);
			open(DATEI, ">backupconfig") or die $1;
				printf DATEI "/home/markus/Script/Perlscript/test\n";
				printf DATEI "/home/markus/Script/Perlscript/Script\n";
				printf DATEI "/home/markus/Script/Perlscript/test2\n";
				printf DATEI "/home/markus/Script/Perlscript/Script\n";
			close(DATEI);
		}	
		else
		{
			open (DATEI, ">logfile") or die $!;
				printf DATEI "ACHTUNG backupconfig DATEI wurde nicht gefunden bitte DATEI erstellen und Pfade der Dateien die kopiert werden sollen eintragen\n";
				printf DATEI "Bitte Vorlage verwenden! Dateiname: backupconfig\n";
				printf DATEI "Pfad/Dateiname\n";
			close (DATEI);
			open(DATEI, ">backupconfig") or die $1;
				printf DATEI "/home/markus/Script/Perlscript/test\n";
				printf DATEI "/home/markus/Script/Perlscript/Script\n";
				printf DATEI "/home/markus/Script/Perlscript/test2\n";
				printf DATEI "/home/markus/Script/Perlscript/Script\n";
			close(DATEI);
		}
	}
}

# Quelleverzeichnis wird aus @configinput genommen
sub su_quelle(@)
{
	my @configinput = @_;
	my $index = @configinput;
	my @quelle;
	my $a;
	my $b = 0;
	for($a=0;$a<$index;$a++)
	{
		if(0 == $a % 2)
		{
			$quelle[$b] = $configinput[$a];
			$b++;
		}
	}
	return @quelle;
}

# Zielverzeichnis wird aus @configinput genommen
sub su_ziel(@)
{
	my @configinput = @_;
	my $index = @configinput;
	my @ziel;
	my $a;
	local $b = 0;
	for($a=0;$a<$index;$a++)
	{
		if(1 == $a % 2)
		{
			$ziel[$b] = $configinput[$a];
			$b++;
		}
	}
	return @ziel;
}

# Dateiname wird aus @configinput genommen
sub su_file(@)
{
	my @quelle = @_;
	my $index = @quelle;
	my @arsplit;
	my @file;
	my $a;
	for($a=0;$a<$index;$a++)
	{
        @arsplit = split(/\//, $quelle[$a]);
        my $arspindex = @arsplit -1;
        $file[$a] = $arsplit[$arspindex];
	}
	return @file;
}

# Dteien werden hier mit cp kopiert 
sub su_cp($;$)
{
	my $fehler = "";
	if($_[1] eq "")
	{
		open (DATEI, ">>logfile") or die $!;
			printf DATEI "Fehler in der config Datei. Datum:	%s\n",su_datum();
		close(DATEI);
		printf "FEHLER IN DER CONFIG DATEI!!!\n";
		$fehler = "true";
	}
	else
	{
		
			system("cp -r $_[0] $_[1]");
			open(DATEI, ">>logfile") or die $!;
				printf DATEI "Datei wurde von	$_[0]	zu	$_[1]	kopiert. Datum: %s\n",su_datum();
			close(DATEI);
			
	}
}	

# wenn die Dateien im Ziel schon sind werden diese hiermit gelöscht 
sub su_loeschen($;$)
{
	if(-e "$_[0]/$_[1]")
	{
		system("rm -r $_[0]/$_[1]"); # Datei im Ziel löschen
		if(-e "logfile")
		{
			open (DATEI, ">>logfile") or die $!;
				printf DATEI "Pfad: $_[0]	Datei: $_[1]	gelöscht. Datum: %s\n",su_datum();
			close (DATEI);
		}
		else
		{
			open (DATEI, ">logfile") or die $!;
				printf DATEI "Pfad:	$_[0] Datei: $_[1]	Datum: %s\n",su_datum();
			close (DATEI);
		}
	}
	else
	{
		open (DATEI, ">>logfile") or die $!;
			printf DATEI "Datei: $_[1] muss nicht gelöscht werden\n";
		close (DATEI);
	}
}

# MD5 hash wird errechnet mit md5sum und verglichen
sub su_md5($;$;$)
{
	my $md5qu = `md5sum -b $_[0]`;
	my @armd5qu = split(/ /, $md5qu );
	my $md5zi = `md5sum -b $_[1]/$_[2]`;
	my @armd5zi = split(/ /, $md5zi );
	my $fehler = "";
	if( $armd5qu[0] eq $armd5zi[0])
	{
			open (DATEI, ">>logfile") or die $!;
			printf DATEI "Datei $_[2] wurde richtig kopiert. MD5-Hash ok. Datum: %s\n",su_datum();
			close(DATEI);
	}
	else
	{
		open(DATEI, ">>logfile") or die $!;
		printf "Datei Datei $_[2] fehlerhaft kopiert Datum: %s\n",su_datum();
		close(DATEI);
		$fehler = "true";
	}
}


### Subroutinen ###

#Datum wird mit date erstellt 
sub su_datum 
{
 my $date = `date`;
 $date =~ s/ //g;
 return $date;
}

#Endcheck
sub su_check
{
	my $fehler = "";
	if($fehler eq "true")
	{
		open (DATEI, ">>logfile") or die $!;
			printf DATEI "fehler\n";
			printf DATEI "BACKUP: %s Status: [failed]\n",su_datum();
		close(DATEI);
	}
	else
	{
		open (DATEI, ">>logfile") or die $!;
			printf DATEI "Alle Daten kopiert\n";
			printf DATEI "BACKUP: %s Status: [OK]\n",su_datum();
		close(DATEI);
		printf "BACKUP: %s  [OK]\n",su_datum();
	}
}

# logfile header wird in logfile geschrieben
sub su_logfile_header($;$;$)
{
	open(DATEI, ">>logfile") or die $!;
		print DATEI "_______________________________\n";
		print DATEI "_______________________________\n";
		printf DATEI "Datei: $_[0]	Quelle: $_[1]	Ziel: $_[2]	Datum: %s \n",su_datum();
	close(DATEI);

}

### Hauptrouttine ###

# Variabeln anlegen
my $GRUEN="\033[32;1m";
my $fehler="";	
my @configinput = Configdatei_laden();
my @quelle = su_quelle(@configinput);
my @ziel = su_ziel(@configinput);
my @file = su_file(@quelle);

# Schleife wird durchlaufen bis jedes Zielverzeichnis abgearbeitet worden ist	
my $i = 0;
foreach(@ziel)
{
	su_logfile_header($file[$i],$quelle[$i],$ziel[$i]);
	su_loeschen($ziel[$i],$file[$i]);
	su_cp($quelle[$i],$ziel[$i]);
	su_md5($quelle[$i],$ziel[$i],$file[$i]);
	$i++;
}
su_check();