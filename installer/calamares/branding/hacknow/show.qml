/* HackNow OS — Calamares slideshow v2
 * 5 ta slayd, har 10 soniyada o'zgaradi, pastida indikator.
 */
import QtQuick 2.5
import calamares.slideshow 1.0

Presentation {
    id: presentation

    property int currentIndex: 0

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            presentation.goToNextSlide();
            presentation.currentIndex = (presentation.currentIndex + 1) % 5;
        }
    }

    // === Umumiy fon ===
    Rectangle {
        anchors.fill: parent
        color: "#0a0a0a"
        z: -1
    }

    // === Slide 1: Welcome ===
    Slide {
        Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                spacing: 24

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Xush kelibsiz!"
                    font.pixelSize: 36
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "HackNow OS o'rnatilmoqda"
                    font.pixelSize: 18
                    color: "#f0f0f0"
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 80
                    height: 2
                    color: "#FF1744"
                    opacity: 0.6
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Birinchi o'zbek pentest distributivi"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                }
            }
        }
    }

    // === Slide 2: Tools ===
    Slide {
        Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                spacing: 22
                width: parent.width * 0.8

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "63+ pentesting asbob"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Tarmoq • Web • Crypto • Forensics • Pwn"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.7
                    height: 1
                    color: "#1a1a1a"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Nmap   ·   Burp Suite   ·   Metasploit   ·   Nuclei\nWireshark   ·   John   ·   Hashcat   ·   Hydra\nSQLMap   ·   FFUF   ·   Gobuster   ·   Volatility"
                    font.pixelSize: 14
                    color: "#f0f0f0"
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.4
                }
            }
        }
    }

    // === Slide 3: HackNow Platform ===
    Slide {
        Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                spacing: 22
                width: parent.width * 0.8

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "HackNow platforma bilan integratsiya"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#FF1744"
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "CTF lablar, amaliyotlar va musobaqalarga\nbevosita OS ichidan ulanish"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.5
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "hn-lab-connect  ·  hn-submit  ·  hn-vpn"
                    font.pixelSize: 13
                    color: "#FF1744"
                    font.family: "Hack Nerd Font, monospace"
                }
            }
        }
    }

    // === Slide 4: O'zbek tilida ===
    Slide {
        Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                spacing: 22

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "100% o'zbek tilida"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Tizim  ·  Dasturlar  ·  Hujjatlar  ·  Qo'llanmalar"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 80
                    height: 2
                    color: "#FF1744"
                    opacity: 0.6
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Hunspell lug'ati  ·  Lotin va kirill\nLibreOffice + Firefox to'liq tarjima"
                    font.pixelSize: 13
                    color: "#f0f0f0"
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.4
                }
            }
        }
    }

    // === Slide 5: Community ===
    Slide {
        Item {
            anchors.fill: parent

            Column {
                anchors.centerIn: parent
                spacing: 22
                width: parent.width * 0.8

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Hamjamiyatga qo'shiling"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#FF1744"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "O'zbekiston kiberxavfsizlik hamjamiyati\nbilan birga o'rganing va o'sing"
                    font.pixelSize: 14
                    color: "#a4b1cd"
                    horizontalAlignment: Text.AlignHCenter
                    lineHeight: 1.5
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 22

                    Text {
                        text: "🌐 hacknow.uz"
                        font.pixelSize: 14
                        color: "#FF1744"
                    }

                    Text {
                        text: "·"
                        font.pixelSize: 14
                        color: "#3d4d60"
                    }

                    Text {
                        text: "📱 t.me/hacknow_uz"
                        font.pixelSize: 14
                        color: "#FF1744"
                    }
                }
            }
        }
    }

    // === Slide indicator (pastki) ===
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        spacing: 8

        Repeater {
            model: 5
            Rectangle {
                width: presentation.currentIndex === index ? 22 : 8
                height: 8
                radius: 4
                color: presentation.currentIndex === index ? "#FF1744" : "#2a2a2a"
                Behavior on width { NumberAnimation { duration: 250 } }
                Behavior on color { ColorAnimation { duration: 250 } }
            }
        }
    }
}
