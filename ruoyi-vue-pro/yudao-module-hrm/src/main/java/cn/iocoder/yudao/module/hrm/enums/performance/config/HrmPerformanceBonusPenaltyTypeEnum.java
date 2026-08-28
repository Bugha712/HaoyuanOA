package cn.iocoder.yudao.module.hrm.enums.performance.config;

import cn.hutool.core.util.ArrayUtil;
import cn.iocoder.yudao.framework.common.core.ArrayValuable;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

/**
 * HRM 绩效加减分类型枚举
 *
 * @author 芋道源码
 */
@Getter
@AllArgsConstructor
public enum HrmPerformanceBonusPenaltyTypeEnum implements ArrayValuable<Integer> {

    BONUS(1, "加分"),
    DEDUCT(2, "减分");

    public static final Integer[] ARRAYS = Arrays.stream(values())
            .map(HrmPerformanceBonusPenaltyTypeEnum::getType).toArray(Integer[]::new);

    /**
     * 类型
     */
    private final Integer type;
    /**
     * 名称
     */
    private final String name;

    @Override
    public Integer[] array() {
        return ARRAYS;
    }

    public static HrmPerformanceBonusPenaltyTypeEnum valueOf(Integer type) {
        return ArrayUtil.firstMatch(item -> item.getType().equals(type), values());
    }

}