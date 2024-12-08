# 2024-11-29

## Plan
 - [ ] gyoll: debug usb hub issue
 - [ ] check out [stylix](https://stylix.danth.me/)

## Notes

- unplugging the usb hub helps
- I think it's putting devices to sleep, repeated after a few minutes went 
  by
- trying to disable autosuspend, and added the thunderbolt kernel module.
- tried forcing the thunderbolt doc to init earlier?

Not sure if any of that worked. The last time I booted the mouse was working?
Something is still strange and I noticed I screwed up my monitor cable. Not
sure if that's related (probably not) but maybe I should fix that.

# 2024-11-27

## Plan

 - [x] Create gyoll - replacing my windows desktop machine
 - [ ] gyoll: set up other hard drives
 - [ ] gyoll: confirm games run with nvidia acceleration'
 - [ ] move swapfile to another hard drive.
 - [ ] move steam games to another drive.

## Notes

Initially, did not set up a swap partition which was a mistake. Running at 
max memory is catastrophic without a swap. Set up a swapfile which helped.

For some reason it decided to try to rebuild cosmic which took a very long 
time. In the middle, i realized it wasn't using the cachix cache like it was
supposed to. I ran `nix flake update` and that helped a bit but it still 
tried to build a lot.

`nvidia-smi` worked right off the bat.

There's a bit of cosmic config stuff that has to be worked out when I first 
start up. I guess it's not a big deal.

Ran into wayland dropping my mouse? Need to replug it in. May be something
related to power management.

# 2024-09-20

## Plan

 - [x] update whorl for all the changes. could get spicy bc of the reused user
 - [ ] try out minikube on whorl

## Notes

Getting whorl up to date what surprisingly easy.

# 2024-09-14

## Plan

- [x] wayland
- [x] optionally install packages depending on xserver.
- [ ] cleanup - reinstall from iso?
- [ ] experiment with kubernetes?
- [x] other cosmic things to install
- [ ] git crypt

## Wayland

asking claude, it looks like all I have to do is

```nix
services.xserver.displayManager.gdm.wayland=true;
```

It looks like claude is very confused about the state of cosmic. I keep 
needing to prompt in that direction.

Oh, I might already be using wayland. lol

```fish
echo $XDG_SESSION_TYPE
wayland
```

## optional xserver-dependent config in modules

- still running into a recursion when I try to use options.
- realized helix clipboard wasn't working. trying wl-clipboard now that I
  know I'm on wayland. That worked.

`mkIf` is a special form that defers evaluation, and therefore avoids the 
recursion. 

## other cosmic things to install

I don't have anything in `cosmic-store` and `cosmic-bg`. How to populate?

They're installed so that's not the problem.

Maybe I don't care.

# 2024-09-13

## Plan

- [x] udev fix for keyboard
- [x] obs studio

## Notes

I'd like to install OBS Studio. I can do it from a flatpack, which should 
work fine. But of course, I'd like to do this as part of my config to make
my life harder.

Also, I'm doing this on my desktop, with a keyboard I've customized. I can't 
remember where the tilde is, so I'd like to use vial.web. That needs some udev
thing.

### Keyboard

I eventually got it to work after screwing around with claude a bit to debug.
Annoyingly hard to get claude to spit out an answer. 

Can install via with `nix-shell -p via` and use that. Alteranatively 
[usevia.app](https://usevia.app) works.

## OBS

I decided to just install the flatpak. So I'm enabling flatpak in nixos. 

There may be a follow up step where I need to do:

```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

That seemed to work. flatpak looks a little scary but whatev.


# 2024-09-08

Tried moving steam over to user-specific config/home-manager.

It's not in home-manager so not doing it there.

Still in user specific config. Ran into infinite recursion problem trying
to access `config.xserver.enable`. Apparently that's an antipattern.

This [thread](https://discourse.nixos.org/t/yet-another-infinite-recursion-problem-configurable-imports/28791/9)
looks helpful - they recommend using [options][] for modules. Don't understand
them yet.

[options]: https://nixos.org/manual/nixos/stable/options

## problems

While trying to suss out that infinite recursion problem (hint: don't refer
to lib.config in a module), I managed to delete my user account? Or at least
get the password messed up. I ended up having to login as root - that password
was fine. Then I could reset the password for my user. The nixos rollbacks
didn't help which isn't too surprising.

Anyway, I can't remember how far I got with the steam thing. I think I just
had to leave it as always on - couldn't optionally detect xsession.

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

- Need to run, for example, `nixos rebuild test --flake` to run the stuff in the
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

[markdown-oxide](https://oxide.md) is interesting. It promises to be an
[Obsidian](https://obsidian.md) for markdown notes.

- [ ] make a `shell.nix` for developing my home files.
- [ ] look into [material-oxide] more. Consider setting up a `.moxide` file for this devlog. 

### Remembering how to use `nix`

I used some blog post to setup `whorl`. How to adapt for `oreb`?

I remember using some [fasterthanlime tutorial][]. I can't remember how I
initially configured flakes, or why I setup this repo like I did. I remember
that I don't like `home-manager`.

[fasterthanlime tutorial]: https://fasterthanli.me/series/building-a-rust-service-with-nix
