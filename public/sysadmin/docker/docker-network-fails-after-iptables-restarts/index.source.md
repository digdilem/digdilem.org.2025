---
date: '2025-06-16T12:40:58+01:00'
draft: false
title: 'Docker Network Fails After Iptables Restarts'
author: Simon Avery
---

For almost a decade, Docker users have been complaining about a specific problem using Docker. This has affected us quite a lot, including taking around 40 docker servers running hundreds of services offline recently when I ran a script that added a local firewall rule. 

The issue is that when Docker starts, it adds whatever rules it needs to talk to the world to the local firewall service. That’s often iptables, but also nftables and probably others. Those rules are temporary and not saved in the firewall’s configuration.

If the firewall is restarted for any reason (such as a sysadmin adding a new port) then those temporary rules are lost by the firewall and Docker can no longer talk to the outside world. Alerts start flashing, people get unhappy – you’ve just lost points in the game of sysadminning.

I researching this problem, and found that Docker’s devs take the firm view that “It’s not Docker’s problem”. I can actually understand that. If other parts of the OS went away, would we expect services to continue running? Some people clearly do – and other software checks basic network continuity and will automatically heal if something like this happens. (Several examples given [in the Github thread](https://github.com/moby/moby/issues/12294) )

But – Docker is Docker and does what Docker does. We needed a workaround or it was only a matter of time before someone (probably me) forgot to restart docker after touching the firewall and broke things again.

My boss came up with what I think is an elegant solution to this ugly problem, using systemd’s `[Unit]` syntaxes.

1. Create a new text file, let’s call it `/etc/systemd/system/docker.service.d/restart-docker-if-firewall-breaks.conf`

    **Explanation:** *.conf files in this directory will be added to Docker’s main .service unit file by systemd, but will both be given a higher priority in case of conflict with that, and persist during updates. Docker’s main service file can be overwritten during normal updates.*

2. That file should contain this text:

    ```
    [Unit]
    After=iptables.service
    Requires=iptables.service
    PartOf=iptables.service
    ```

    **Note:** Replace iptables with nftables if that is your local firewall (Debian, Rocky9 etc)

    **Explanation:**

    `After` = *Ensures that the listed unit is fully started up before the configured unit is started*
    `Requires` = *If this unit gets activated, the units listed will be activated as well*
    `PartOf` = *When systemd stops or restarts the units listed here, the action is propagated to this unit*

    In short, don’t run until iptables is already up, and if that restarts, restart docker.
    **Reference:** [Systemd documentation](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html)

3. Lastly, we need to tell systemd about the change with `systemctl daemon-reload`
    We don’t need to restart the Docker service for this.

4. Testing (Optional)

   To test this works, restart iptables: `systemctl restart iptables`

   Then check docker’s service status and you should see it’s restarted recently too. `systemctl status docker`

That’s it! You can walk away and know that if the local firewall is restarted, instead of docker breaking completely, it will restart and repopulate the firewall with its own temporary rules. You might lose connection to those services briefly, but it will auto-heal.

