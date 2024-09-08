# 2024-09-08

Tried mvoving steam over to user-specific config/home-manager.

It's not in home-manager so not doing it there.

Still in user specific config. Ran into infinite recursion problem trying
to access `config.xserver.enable`. Apparently that's an antipattern.

This [thread](https://discourse.nixos.org/t/yet-another-infinite-recursion-problem-configurable-imports/28791/9)
looks helpful - they recommend using [options][] for modules. Don't understand
them yet.

[options]: https://nixos.org/manual/nixos/stable/options

# 2024-09-06

## TODO

- [ ] refactor!
    - [x] move flake to root
    - [x] rename machines to hosts
    - [x] `shell.nix`
    - [ ] make `home/` for `home-manager` stuff
        - [ ] move stuff over

## Notes

- I got chrome to not be blurry! Thanks to this [thread](https://askubuntu.com/questions/1472847/google-chrome-is-blurry-on-ubuntu-23-04-wayland-nvidia-3050-ti-hidpi-screen-w).

- Need to run, for example, `nixos rebuid test --flake` to run the stuff in the
  current directory. Otherwise I get a weird error about  nixos-config not being
  present.

# 2024-09-03

## TODO

- [x] check on that issue
- [x] check out using cosmic on a stable nixos
- [x] try out cosmic. Do I like it?
    - [x] does steam work ok (Yes)

Switching to 24.05 works, of course.

Cosmic seems ok! Does tiling, seems reasonable so far?

# 2024-09-02

## TODO

- [x] enable flakes on current config
- [x] create `oreb` machine in `home` 
- [x] install chrome
- [x] install steam
- [x] ~popos cosmic~

## Cosmic

Following [README](https://github.com/lilyinstarlight/nixos-cosmic/)

Starting by brute forcing for `oreb` but would like to make it optional for
`whorl`.

First try, no text showed up.

It looks like a recent [bug](https://github.com/NixOS/nixpkgs/issues/338933).

Looks like this is a little too new :)

I'm still doing gnome for now and will look at i3. It looks like the issue could
get resolved pretty soon, so maybe if I check back in a few days.

In the meantime, I should just cleanup my setup in this repo.

There are other directions. I could look into wayland, but that also looks too
new (i.e. for steam). I'm not sure I see the upside either. Lots of folks have
gone down the route of ricing with i3 and rofi et al. If I get my home packages
in order, this might be fun.  However, at that point cosmic might be fixed.

## Tips

```bash
nix flake update <dir> # updates the flake.lock file in <dir>
sudo nixos-rebuild update --flake <dir> # rebuild and update the system 
```

## Notes

It's sooooo nice to get all my home files setup on reboot. It's actually
insane that this works so well.

I'm tempted to give home-manager another chance. I definitely need to 
reorganize the code a bit. It's hard to tell what's done where. I've split
things into too many files.

## Enabling flakes

Following [this](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled).

Add this to `/etc/nixos/configuration.nix`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Followed by a 

```bash
sudo nixos-rebuild switch
```

Got a warning:

```
trace: warning: The option `services.xserver.displayManager.autoLogin'
defined in `/etc/nixos/configuration.nix' has been renamed to
`services.displayManager.autoLogin'.
```

## Aside

The keyboard layout on this zenbook leaves a lot to be desired.


# 2024-09-01

I have an Asus Zenbook UX371E laptop. I had been running a mix of PopOS 22.04
and Regolith, and then left the laptop alone for a long time. Since then,
I've been playing around with NixOS on a virtual machine, `whorl`. This weekend
I decided to go ahead and bite the bullet and try it on this laptop. There were
a couple things I found encouraging:

1. I can start with the [NixOS Gnome ISO][].
2. There's a [hardware overlay][] for this laptop.
3. PopOS's new version [Cosmic][] has a [Nix thing](https://github.com/lilyinstarlight/nixos-cosmic).
4. Steam should work with Nix.

With Nix, I have checkpointed systems. In theory, I should be able to start with
that Gnome ISO, and rip everything apart to my hearts content to try things out.

Steam is the only real reason to have this linux laptop since I can rely on
virtual machines almost anywhere else.

[NixOS Gnome ISO]: https://nixos.org/download/
[hardware overlay]: https://github.com/NixOS/nixos-hardware/tree/master/asus/zenbook/ux371
[Cosmic]: https://system76.com/cosmic 

## Initial setup

### First steps 

## Getting my [home](https://github.com/nclack/home) files

It turns out that the github cli `gh` will do all the hard work of setting up an
ssh key and uploading it.

```bash
nix-shell -p gh git
gh auth login # follow the flow to generate and upload a key
gh repo clone nclack/home
```

Q: What happens to the ssh key when I exit the shell? Will `gh` recognize
that I'm logged in next time?
A: Yes, it does seem to keep me logged in.

## Start editing stuff

I need an editor for this devlog and the nix files.

```bash
nix-shell -p hx nil markdown-oxide
```

[markdown-oxide](https://oxide.md) is intersting. It promisses to be an
[Obsidian](https://obsidian.md) for markdown notes.

- [ ] make a `shell.nix` for developing my home files.
- [ ] look into [material-oxide] more. Consider setting up a `.moxide` file for this devlog. 

### Remembering how to use `nix`

I used some blog post to setup `whorl`. How to adapt for `oreb`?

I remember using some [fasterthanlime tutorial][]. I can't remember how I
initially configured flakes, or why I setup this repo like I did. I remember
that I don't like `home-manager`.

[fasterthanlime tutorial]: https://fasterthanli.me/series/building-a-rust-service-with-nix
