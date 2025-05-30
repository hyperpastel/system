<div id="toc" align="center">
  <ul style="list-style: none">
    <summary>
      <h1> hyperpastel's NixOS Configuration </h1>
    </summary>
  </ul>
</div>

> [!CAUTION] 
> These are my personal files, tuned specifically for my own hardware and workflow.
> This setup **won't work** on your machine without modification. 

This repository houses my NixOS configuration. It is [flake](https://nixos.wiki/wiki/Flakes)-based and utilizes [impermanence](https://nixos.wiki/wiki/Impermanence) to 
further explore reproducibility.

While only fitted for my Dell Inspiron Laptop at the moment, this might be extended to support multiple systems later on.

## 🧱 Structure 

### 📁 modules

This folder contains all the configuration for the system, organized into modular ``.nix`` files, grouped by functionality. </br>
A few selected 'highlights' among these include:

**❄️ boot.nix** and **❄️ persistence.nix**

These two files realize the impermanent aspect of the system. On every boot, the ``/root`` partition is reset to a blank state that was recorded after the initial installation.
Important files that need to survive this (primarily file in ``/etc/``) are either:
  - Symlinked from a separate ``/persist`` partition
  - or created through Nix itself and symlinked from the Nix Store


## 📚 References
- Impermanence
  - [Encrypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html) by mt-caret
  - [Erase your darlings](https://grahamc.com/blog/erase-your-darlings/) by Graham Christensen

