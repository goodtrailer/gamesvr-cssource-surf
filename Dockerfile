FROM lacledeslan/gamesvr-cssource AS cssource

# ---

FROM debian:bookworm-slim AS addons

RUN apt-get update \
    && apt-get install -y libarchive-tools git

RUN mkdir -p /app/cstrike

# Metamod:Source (build 1219)
ADD https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1219-linux.tar.gz /metamod.tar.gz
RUN bsdtar -xvf /metamod.tar.gz -C /app/cstrike

# SourceMod (build 7209)
ADD https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7209-linux.tar.gz /sourcemod.tar.gz
RUN bsdtar -xvf /sourcemod.tar.gz -C /app/cstrike

# sm-ripext (v1.3.1)
ADD https://github.com/ErikMinekus/sm-ripext/releases/download/1.3.1/sm-ripext-1.3.1-linux.zip /sm-ripext.zip
RUN bsdtar -xvf /sm-ripext.zip -C /app/cstrike

# shavit-bhoptimer (v3.5.1 - goodtrailer fork)
ADD https://github.com/goodtrailer/bhoptimer/releases/download/v3.5.1/bhoptimer.zip /shavit-bhoptimer.zip
RUN bsdtar -xvf /shavit-bhoptimer.zip -C /app/cstrike

# shavit-myreplay (v1.0.4)
ADD https://github.com/BoomShotKapow/shavit-myreplay/releases/download/1.0.4/shavit-myreplay-1.0.4-sm1.12.x.zip /shavit-myreplay.zip
RUN bsdtar -xvf /shavit-myreplay.zip -C /app/cstrike/addons/sourcemod

# MomSurfFix2 (v1.1.5)
ADD https://github.com/GAMMACASE/MomSurfFix/releases/download/1.1.5/MomSurfFix2v1.1.5.zip /momsurffix2.zip
RUN bsdtar -xvf /momsurffix2.zip -C /app/cstrike

# RNGFix (v1.1.3)
ADD https://github.com/jason-e/rngfix/releases/download/v1.1.3/rngfix_1.1.3.zip /rngfix.zip
RUN bsdtar -xvf /rngfix.zip --strip-components=1 -C /app/cstrike/addons/sourcemod

# HeadBugFix (v1.0.0)
ADD https://github.com/GAMMACASE/HeadBugFix/releases/download/1.0.0/headbugfix_1.0.0.zip /headbugfix.zip
RUN bsdtar -xvf /headbugfix.zip -C /app/cstrike

# DynamicChannels (2024.720.0)
RUN git clone https://github.com/Vauff/DynamicChannels \
    && cd DynamicChannels \
    && git checkout 9502f2b \
    && cd .. \
    && mv DynamicChannels/plugins/DynamicChannels.smx /app/cstrike/addons/sourcemod/plugins

# sm_closestpos (v1.1.1)
ADD https://github.com/rtldg/sm_closestpos/releases/download/v1.1.1/sm_closestpos-sm1.10-ubuntu-22.04-f848dfc.zip /sm_closestpos.zip
RUN bsdtar -xvf /sm_closestpos.zip -C /app/cstrike

# SuppressViewpunch (2025.203.0)
ADD https://github.com/goodtrailer/SuppressViewpunch/releases/download/2025.203.0/SuppressViewpunch.zip /suppressviewpunch.zip
RUN bsdtar -xvf /suppressviewpunch.zip -C /app/cstrike

# hide-motd (2025.705.0)
ADD https://github.com/goodtrailer/hide-motd/releases/download/2025.705.0/hide-motd.zip /hide-motd.zip
RUN bsdtar -xvf /hide-motd.zip -C /app/cstrike

# ---

FROM cssource

COPY --chown=CSSource:root --from=addons /app /app
COPY --chown=CSSource:root /app-cfg /app

RUN usermod -l CSSourceSurf CSSource
USER CSSourceSurf

ONBUILD USER root
