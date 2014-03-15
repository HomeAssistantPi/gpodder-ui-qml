
/**
 *
 * gPodder QML UI Reference Implementation
 * Copyright (c) 2013, 2014, Thomas Perl <m@thp.io>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 */

import QtQuick 2.0

import 'common'
import 'common/util.js' as Util
import 'common/constants.js' as Constants
import 'icons/icons.js' as Icons

SlidePage {
    id: episodesPage

    hasPull: true

    property int podcast_id
    property string title

    width: parent.width
    height: parent.height

    Component.onCompleted: {
        episodeListModel.podcast_id = podcast_id;
        episodeListModel.setQuery(episodeListModel.queries.All);
        episodeListModel.reload();
    }

    EpisodeQueryControl {
        id: queryControl
        model: episodeListModel
        title: 'Select filter'
    }

    PullMenu {
        PullMenuItem {
            text: 'Now Playing'
            icon: Icons.play
            color: Constants.colors.playback
            onClicked: {
                pgst.loadPage('PlayerPage.qml');
                episodesPage.unPull();
            }
        }

        PullMenuItem {
            text: 'Mark all as old'
            icon: Icons.eye
            color: Constants.colors.text
            onClicked: {
                py.call('main.mark_episodes_as_old', [episodesPage.podcast_id]);
                episodesPage.unPull();
            }
        }

        PullMenuItem {
            text: 'Unsubscribe'
            icon: Icons.trash
            color: Constants.colors.destructive
            onClicked: {
                episodesPage.unPull();

                var ctx = { py: py, id: episodesPage.podcast_id, page: episodesPage };
                pgst.showConfirmation('Unsubscribe', Icons.trash, function () {
                    ctx.py.call('main.unsubscribe', [ctx.id]);
                    ctx.page.closePage();
                });
            }
        }
    }

    PListView {
        id: episodeList
        property int selectedIndex: -1
        title: episodesPage.title
        model: GPodderEpisodeListModel { id: episodeListModel }

        headerHasIcon: true
        headerIconText: 'Filter'
        onHeaderIconClicked: queryControl.showSelectionDialog();

        PPlaceholder {
            text: 'No episodes'
            visible: episodeList.count === 0
        }

        delegate: EpisodeItem { }
    }
}

