import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0a0a0a"

            Column {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "HackNow OS ga xush kelibsiz!"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Birinchi o'zbek pentesting distributivi"
                    font.pixelSize: 16
                    color: "#f0f0f0"
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0a0a0a"

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "63+ Pentesting Toollar"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Nmap, Burp Suite, Metasploit, Nuclei,\nWireshark, John, Hashcat va boshqalar..."
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0a0a0a"

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "HackNow Platforma Integratsiyasi"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "CTF lablar, mashqlar va musobaqalarga\nbevosita OS ichidan ulaning"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0a0a0a"

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "O'zbek tilida"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Interfeys, hujjatlar va qo'llanmalar\nto'liq o'zbek tilida"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0a0a0a"

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Jamiyat"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "hacknow.uz | t.me/hacknow_uz\n\nO'zbekiston kiberxavfsizlik hamjamiyati\nbilan birga o'rganing va o'sing!"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
