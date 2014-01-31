import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import 'common'
import 'common/util.js' as Util

ApplicationWindow {
    width: 500
    height: 400

    title: 'gPodder'

    GPodderCore {
        id: py

        onReadyChanged: {
            if (ready) {
                py.call('main.load_podcasts', [], function (podcasts) {
                    Util.updateModelFrom(podcastListModel, podcasts);
                });
            }
        }
    }

    menuBar: MenuBar {
        Menu { title: 'File'; MenuItem { text: 'Quit' } }
    }

    SplitView {
        anchors.fill: parent

        TableView {
            width: 200
            model: ListModel { id: podcastListModel }
            headerVisible: false
            alternatingRowColors: false

            rowDelegate: Rectangle {
                height: 60
                color: styleData.selected ? '#eee' : '#fff'
            }

            TableViewColumn {
                role: 'coverart'
                title: 'Image'
                delegate: Item {
                    height: 60
                    width: 60
                    Image {
                        source: styleData.value
                        width: 50
                        height: 50
                        anchors.centerIn: parent
                    }
                }

                width: 60
            }

            TableViewColumn {
                role: 'title'
                title: 'Podcast'
                delegate: Item {
                    height: 60
                    Text {
                        text: styleData.value
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            onCurrentRowChanged: {
                var id = podcastListModel.get(currentRow).id;
                py.call('main.load_episodes', [id], function (episodes) {
                    Util.updateModelFrom(episodeListModel, episodes);
                });
            }
        }

        TableView {
            Layout.fillWidth: true
            model: ListModel { id: episodeListModel }

            TableViewColumn { role: 'title'; title: 'Title' }
        }
    }
}
