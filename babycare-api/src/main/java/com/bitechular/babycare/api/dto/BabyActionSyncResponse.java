package com.bitechular.babycare.api.dto;

import java.util.Date;
import java.util.List;

public class BabyActionSyncResponse {
    public List<BabyActionDto> actions;
    public long syncedDate;

    public BabyActionSyncResponse(List<BabyActionDto> actions, Date syncedDate) {
        this.actions = actions;
        this.syncedDate = syncedDate.getTime();
    }

    public List<BabyActionDto> getActions() {
        return actions;
    }

    public void setActions(List<BabyActionDto> actions) {
        this.actions = actions;
    }

    public long getSyncedDate() {
        return syncedDate;
    }

    public void setSyncedDate(long syncedDate) {
        this.syncedDate = syncedDate;
    }
}
