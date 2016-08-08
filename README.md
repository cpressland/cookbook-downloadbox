# cpio-downloads-server - Cookbook

Cookbook for deploying NZBGet, Sonarr and CouchPotato onto a CentOS Server.

## Supported Platforms

* CentOS 7.x

## Usage

Deployment on a CentOS Server can be automated by calling the following script:

```
curl -L https://raw.githubusercontent.com/cpressland/cpio-downloads-server/master/install.sh | bash
```

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cpio-downloads-server']['apps_username']</tt></td>
    <td>Text</td>
    <td>Name of the user NZBGet, qBittorrent, Sonarr and CouchPotato will run as</td>
    <td><tt>apps</tt></td>
  </tr>
  <tr>
    <td><tt>['fish']['replace_bash']</tt></td>
    <td>Boolean</td>
    <td>Whether to replace bash with Fish for the root user</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['firewalld']['enable_firewalld']</tt></td>
    <td>Boolean</td>
    <td>Whether to enable firewalld and configure ports</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['smb']['enable_smb']</tt></td>
    <td>Boolean</td>
    <td>Whether to enable a anonymous SMB share to the Downloads location</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['nzbget']['webui']</tt></td>
    <td>Number</td>
    <td>Default Port for NZBGet WebUI</td>
    <td><tt>6789</tt></td>
  </tr>
  <tr>
    <td><tt>['qbittorrent']['webui']</tt></td>
    <td>Number</td>
    <td>Default Port for qBittorrent WebUI</td>
    <td><tt>8080</tt></td>
  </tr>
  <tr>
    <td><tt>['qbittorrent']['torrentport']</tt></td>
    <td>Number</td>
    <td>Default Incoming Port for Torrent Traffic</td>
    <td><tt>51413</tt></td>
  </tr>
  <tr>
    <td><tt>['sonarr']['webui']</tt></td>
    <td>Number</td>
    <td>Default Port for Sonarr WebUI</td>
    <td><tt>8989</tt></td>
  </tr>
  <tr>
    <td><tt>['couchpotato']['webui']</tt></td>
    <td>Number</td>
    <td>Default Port for CouchPotato WebUI</td>
    <td><tt>5050</tt></td>
  </tr>
  <tr>
    <td><tt>['cpio-downloads-server']['dl_directory']</tt></td>
    <td>Text</td>
    <td>Path Download Clients and SMB Share use</td>
    <td><tt>/downloads</tt></td>
  </tr>
  <tr>
    <td><tt>['cpio-downloads-server']['share_ip']</tt></td>
    <td>Text</td>
    <td>AutoFS Share IP, this would probably be your NAS, UnRAID or Plex Server</td>
    <td><tt>10.0.50.10</tt></td>
  </tr>
  <tr>
    <td><tt>['cpio-downloads-server']['share_name']</tt></td>
    <td>Text</td>
    <td>AutoFS Share Name, this would probably be your NAS, UnRAID or Plex Server</td>
    <td><tt>shared</tt></td>
  </tr>
</table>

## Todo List

* Add Support for Optional Nginx Reverse Proxy
* Add Tmux and Tmuxinator with a view of all logs
* Add Additional Attributes for customising NZBGet, qBittorrent, Sonarr & CouchPotato
* Continue refining code
* Switch to Alpine Linux based Docker containers.

## License and Authors

Author:: Chris Pressland (mail@cpressland.io)
