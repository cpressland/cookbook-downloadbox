# cpio-downloads-server-cookbook

TODO: I'll do this later.

## Supported Platforms

* CentOS 7.x

## Attributes

I'll fill these out later

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cpio-downloads-server']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### cpio-downloads-server::default

Include `cpio-downloads-server` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cpio-downloads-server::default]"
  ]
}
```

## License and Authors

Author:: Chris Pressland (mail@cpressland.io)
