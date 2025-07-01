FROM lacledeslan/gamesvr-cssource AS cssource

# ---

FROM debian:bookworm-slim AS addons

RUN apt-get update \
    && apt-get install -y libarchive-tools

RUN mkdir -p /app/cstrike

# Metamod:Source (build 1219)
ADD https://mms.alliedmods.net/mmsdrop/1.12/mmsource-1.12.0-git1219-linux.tar.gz /metamod.tar.gz
RUN bsdtar -xvf /metamod.tar.gz -C /app/cstrike

# SourceMod (build 7209)
ADD https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7209-linux.tar.gz /sourcemod.tar.gz
RUN bsdtar -xvf /sourcemod.tar.gz -C /app/cstrike

# shavit's bhoptimer (v3.5.1)
ADD https://github.com/shavitush/bhoptimer/releases/download/v3.5.1/bhoptimer-v3.5.1.zip /bhoptimer.zip
RUN bsdtar -xvf bhoptimer.zip --strip-components=1 -C /app/cstrike

# MomSurfFix2 (v1.1.5)
ADD https://github.com/GAMMACASE/MomSurfFix/releases/download/1.1.5/MomSurfFix2v1.1.5.zip /momsurffix2.zip
RUN bsdtar -xvf /momsurffix2.zip -C /app/cstrike

# RNGFix (v1.1.3)
ADD https://github.com/jason-e/rngfix/releases/download/v1.1.3/rngfix_1.1.3.zip /rngfix.zip
RUN bsdtar -xvf /rngfix.zip --strip-components=1 -C /app/cstrike/addons/sourcemod

# HeadBugFix (v1.0.0)
ADD https://github.com/GAMMACASE/HeadBugFix/releases/download/1.0.0/headbugfix_1.0.0.zip /headbugfix.zip
RUN bsdtar -xvf /headbugfix.zip -C /app/cstrike

# sm_closestpos (v1.1.1)
ADD https://github.com/rtldg/sm_closestpos/releases/download/v1.1.1/sm_closestpos-sm1.10-ubuntu-22.04-f848dfc.zip /sm_closestpos.zip
RUN bsdtar -xvf /sm_closestpos.zip -C /app/cstrike

# ---

FROM cssource

COPY --chown=CSSource:root --from=addons /app /app
COPY --chown=CSSource:root /app-cfg /app

RUN usermod -l CSSourceSurf CSSource
USER CSSourceSurf

ONBUILD USER root
